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
import '../../apply/create_apply_page.dart';

class ListBookingItem extends StatefulWidget {
  final Booking booking;
  const ListBookingItem({super.key, required this.booking});

  @override
  State<ListBookingItem> createState() => _ListBookingItemState();
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
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateApplyPage(booking: widget.booking)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  child: InkWell(
                    onTap: () {
                      appRouter.push(DetailPageRoute(booking: widget.booking));
                    },
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
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.booking.startPointMainText,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(widget.booking.startPointAddress,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.booking.endPointMainText,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    Text(widget.booking.endPointAddress,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            (isNavigateChatRoom)
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      navigateChatRoom(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(120, 30),
                                        maximumSize: const Size(120, 30),
                                        backgroundColor:
                                            AppColors.primaryColor),
                                    child: const Text(
                                      'Trò chuyện',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                            (isNavigateCreateApply)
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      navigateCreateApply(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(100, 30),
                                        maximumSize: const Size(100, 30),
                                        backgroundColor:
                                            AppColors.primaryColor),
                                    child: const Text(
                                      'Apply',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
