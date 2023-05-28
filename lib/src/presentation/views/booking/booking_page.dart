import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubits/booking/booking_cubit.dart';
import '../../models/booking.dart';
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
                  (state.listAvailable.length == 0)
                      ? Center(
                          child: Column(
                          children: [
                            Image.asset('assets/images/error.png'),
                            const Text(
                              'Danh sách trống!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ))
                      : ListBooking(bookings: state.listAvailable),
                  (state.listComplete.length == 0)
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/error.png'),
                            const Text(
                              'Danh sách trống!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ))
                      : ListBooking(bookings: state.listComplete),
                  (state.listCancel.length == 0)
                      ? Center(
                          child: Column(
                          children: [
                            Image.asset('assets/images/error.png'),
                            const Text(
                              'Danh sách trống!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ))
                      : ListBooking(
                          bookings: state.listCancel,
                        )
                ],
              ),
            ),
          ],
        );
      } else {
        return Center(
            child: Column(
          children: [
            Image.asset('assets/images/error.png'),
            const Text(
              'Danh sách trống!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ));
      }
    });
  }
}
