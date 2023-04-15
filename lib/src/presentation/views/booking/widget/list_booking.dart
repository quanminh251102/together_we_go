// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../models/booking.dart';
import 'list_booking_item.dart';

class ListBooking extends StatefulWidget {
  final List<Booking> bookings;
  const ListBooking({
    Key? key,
    required this.bookings,
  }) : super(key: key);

  @override
  State<ListBooking> createState() => _ListBookingState();
}

class _ListBookingState extends State<ListBooking> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListBookingItem(
          booking: widget.bookings[index],
        );
      },
      itemCount: widget.bookings.length,
    );
  }
}
