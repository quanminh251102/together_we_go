import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/booking/booking_cubit.dart';
import 'widget/list_booking.dart';

class BookingPage extends StatefulWidget {
  final TabController tabController;
  const BookingPage({super.key, required this.tabController});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BookingCubit>(context).getListBooking();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(listener: (context, state) {
      if (state is BookingError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error in Booking '),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is BookingLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is BookingLoaded) {
        return Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: widget.tabController,
                children: <Widget>[
                  ListBooking(bookings: state.listAvailable),
                  ListBooking(bookings: state.listComplete),
                  ListBooking(
                    bookings: state.listCancel,
                  )
                ],
              ),
            ),
          ],
        );
      } else {
        return const Center(child: Text('Danh sách trống'));
      }
    });
  }
}
