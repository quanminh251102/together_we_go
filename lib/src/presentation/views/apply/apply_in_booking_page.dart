import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/booking.dart';
import '../../services/apply.dart';

class ApplyInBookingPage extends StatefulWidget {
  final Booking booking;
  const ApplyInBookingPage({super.key, required this.booking});

  @override
  State<ApplyInBookingPage> createState() => _ApplyInBookingPageState();
}

class _ApplyInBookingPageState extends State<ApplyInBookingPage> {
  bool isLoading_getApplyInBooking = false;
  List<dynamic> applys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  void init() async {
    setState(() {
      isLoading_getApplyInBooking = true;
    });

    String result = "pass";

    try {
      applys = await ApplyService.getApplyInBooking(widget.booking.id);
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
      isLoading_getApplyInBooking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply của bài đăng')),
      body: Column(
        children: [],
      ),
    );
  }
}
