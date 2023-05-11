import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../services/booking.dart';
import 'widget/my_booking_item.dart';

class MyBookPage extends StatefulWidget {
  const MyBookPage({super.key});

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  bool isLoading_getMyBook = false;
  List<dynamic> bookings = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  void init() async {
    setState(() {
      isLoading_getMyBook = true;
    });

    String result = "pass";

    try {
      bookings = await BookingService.getMyBooking();
    } catch (e) {
      result = "error";
    }

    if (result == "error") {
      const snackBar = SnackBar(
        content: Text('Bị lổi'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        content: Text('Thành công'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading_getMyBook = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài đăng của tôi'),
        centerTitle: true,
      ),
      body: isLoading_getMyBook
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                children: [
                  (bookings.length == 0)
                      ? Text('Danh sách rỗng')
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return MyBookingItem(
                                booking: bookings[index],
                              );
                            },
                            itemCount: bookings.length,
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
