import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:together_we_go/src/presentation/views/apply/widgets/apply_in_booking_item.dart';

import '../../models/booking.dart';
import '../../services/apply.dart';

class ApplyInBookingPage extends StatefulWidget {
  final dynamic booking;
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

    // print(widget.booking.toString());
    try {
      applys = await ApplyService.getApplyInBooking(widget.booking["_id"]);
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
      body: isLoading_getApplyInBooking
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                children: [
                  (applys.length == 0)
                      ? Text('Danh sách rỗng')
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return ApplyInBookItem(
                                apply: applys[index],
                                reload: init,
                              );
                            },
                            itemCount: applys.length,
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
