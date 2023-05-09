import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../config/router/app_router.dart';
import '../../../../utils/constants/colors.dart';
import '../../../cubits/chat/message_cubit.dart';
import '../../../models/booking.dart';
import '../../../models/chat_room.dart';
import '../../../services/chat_room.dart';
import '../../chat/chat_page.dart';

class ListBookingItem extends StatefulWidget {
  final Booking booking;
  const ListBookingItem({super.key, required this.booking});

  @override
  State<ListBookingItem> createState() => _ListBookingItemState();
}

String formatString(String input) {
  if (input.length > 30) {
    return input.substring(0, 27) + "...";
  } else {
    return input;
  }
}

class _ListBookingItemState extends State<ListBookingItem> {
  bool isNavigateChatRoom = false;
  bool isNavigateCreateApply = false;

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

  void navigateCreateApply(BuildContext context) async {
    setState(() {
      isNavigateCreateApply = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isNavigateCreateApply = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Card(
        elevation: 3,
        shadowColor: Colors.grey,
        child: Container(
          color: Colors.white.withOpacity(0.85),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(widget.booking.authorAvatar)),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.booking.authorName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.booking.contact,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          widget.booking.bookingType,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.booking.status == 'available'
                                ? AppColors.primaryColor
                                : widget.booking.status == 'complete'
                                    ? Colors.green
                                    : Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.booking.status.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ))
                  ]),
                ),
                ExpansionTile(
                  title: const Text('Chi tiết'),
                  children: [
                    Text(widget.booking.content,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/distance.svg",
                                height: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.booking.distance,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/clock.svg",
                                height: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.booking.duration,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/wallet.svg",
                                height: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${widget.booking.price} VND',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: Row(
                        children: [
                          const Text(
                            'Thời gian: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            widget.booking.time,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/location-svgrepo-com.svg',
                              height: 40,
                            ),
                            SvgPicture.asset(
                              'assets/svg/downarrow.svg',
                              height: 40,
                            ),
                            SvgPicture.asset(
                              'assets/svg/location.svg',
                              height: 40,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatString(
                                            widget.booking.startPointMainText),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.booking.startPointAddress),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatString(
                                          widget.booking.endPointMainText),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.booking.endPointAddress,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (isNavigateChatRoom)
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                navigateChatRoom(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              child: Text(
                                'Đến khung chat',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      (isNavigateCreateApply)
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                navigateCreateApply(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              child: Text(
                                'Apply',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
