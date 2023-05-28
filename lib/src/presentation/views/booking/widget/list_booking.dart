// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../models/booking.dart';
import 'list_booking_item.dart';

class ListBooking extends StatelessWidget {
  final List<Booking> bookings;
  const ListBooking({
    Key? key,
    required this.bookings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListBookingItem(
          booking: bookings[index],
        );
      },
      itemCount: bookings.length,
    );
  }
}
