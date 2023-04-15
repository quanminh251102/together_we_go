import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../models/booking.dart';

class ListBookingItem extends StatefulWidget {
  final Booking booking;
  const ListBookingItem({super.key, required this.booking});

  @override
  State<ListBookingItem> createState() => _ListBookingItemState();
}

class _ListBookingItemState extends State<ListBookingItem> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final date = DateFormat('yyyy-MM-dd hh:mm:ss').format(widget.booking.time);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Card(
        elevation: 3,
        shadowColor: Colors.grey,
        child: Container(
          color: Colors.white.withOpacity(0.85),
          height: size.height * 0.4,
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
                        height: 50,
                        width: 50,
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
                          child: Text(widget.booking.status),
                        ))
                  ]),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
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
                          const Text(
                            '4,5 km',
                            style: TextStyle(
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
                          const Text(
                            '15 phút',
                            style: TextStyle(
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      const Text(
                        'Thời gian: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/location-svgrepo-com.svg',
                          height: 30,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.booking.startPoint,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SvgPicture.asset(
                        'assets/svg/downarrow.svg',
                        height: 30,
                        width: 100,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/location.svg',
                          height: 30,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.booking.endPoint,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
