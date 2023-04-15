import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubits/booking/cubit/booking_cubit.dart';
import '../../models/booking.dart';
import 'widget/list_booking.dart';

class BookingPage extends StatefulWidget {
  final TabController tabController;
  const BookingPage({super.key, required this.tabController});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Booking> bookings = Booking.list;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BookingCubit>(context).getListBooking();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error in Booking '),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (state is BookingInitial) {
            return const Center(child: Text('Danh sách trống'));
          } else {
            {
              return Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: widget.tabController,
                      children: <Widget>[
                        ListBooking(bookings: bookings),
                        Icon(Icons.directions_transit, size: 350),
                        Icon(Icons.directions_car, size: 350),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        }
      },
    );
  }
}
