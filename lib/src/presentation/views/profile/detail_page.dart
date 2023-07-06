// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/colors.dart';
import '../../cubits/app_user.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../models/author.dart';
import '../../models/booking.dart';
import '../../models/chat_room.dart';
import '../../services/booking.dart';
import '../../services/chat_room.dart';
import '../../services/review.dart';

class DetailPage extends StatefulWidget {
  final Booking booking;
  const DetailPage({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Author? author;
  bool isNavigateChatRoom = false;
  bool isNavigateCreateApply = false;
  List<dynamic> reviews = [];
  List<dynamic> bookings = [];
  double rating = 0;
  List<dynamic> completeBooking = [];
  bool isLoading_getMyBook = false;
  void init() async {
    setState(() {
      isLoading_getMyBook = true;
    });
    try {
      bookings = await BookingService.getBookingWithId(author!.id.toString());
      completeBooking =
          await BookingService.getMyCompleteBooking(author!.id.toString());
      reviews = await ReviewService.getReviewWithUserId(appUser.id);
      double sumRating = 0;
      for (var review in reviews) {
        sumRating += review["review_star"];
      }
      rating = sumRating / reviews.length;
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading_getMyBook = false;
    });
  }

  void navigateChatRoom(BuildContext context) async {
    setState(() {
      isNavigateChatRoom = true;
    });
    // Rawait Future.delayed(Duration(seconds: 2));
    String result = "pass";
    ChatRoom chatRoom = ChatRoom(
        id: '',
        partner_name: '',
        partner_gmail: '',
        partner_avatar: '',
        partner_id: '',
        numUnWatch: 0,
        lastMessage: {});
    try {
      await ChatRoomService.getChatRoomInBooking(widget.booking.authorId)
          .then((value) {
        chatRoom = value;
      });
    } catch (e) {
      result = "error";
    }
    if (result == "pass") {
      BlocProvider.of<MessageCubit>(context).setChatRoom(chatRoom);
      BlocProvider.of<MessageCubit>(context).get_message();
      BlocProvider.of<MessageCubit>(context).join_chat_room();
      appRouter.push(const ChatPageRoute());
    }
    setState(() {
      isNavigateChatRoom = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    author = widget.booking.accountDetail;
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
      ),
      body: isNavigateChatRoom || isLoading_getMyBook
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    author?.avatarUrl ??
                        'https://static-00.iconduck.com/assets.00/person-icon-476x512-hr6biidg.png',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  author?.firstName ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  author?.phoneNumber ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 25,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Đánh giá',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 25,
                                child: Icon(
                                  Icons.book,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                bookings.length.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Bài đăng',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 25,
                                child: Icon(
                                  Icons.car_rental,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                completeBooking.length.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Chuyến đi',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Địa chỉ:',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${author?.locationMainText}, ${author?.locationAddress}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Email: ',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                author?.email ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ngày sinh: ',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                    author?.birthDate ??
                                        DateTime.now().toString())),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateChatRoom(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 30,
                        child: Icon(
                          Icons.message,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateChatRoom(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 30,
                        child: Icon(
                          Icons.call,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
