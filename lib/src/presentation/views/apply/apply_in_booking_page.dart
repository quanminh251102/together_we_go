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
  List<dynamic> applys_selected = [];
  TextEditingController _name = TextEditingController();

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
      applys_selected = applys;
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

  void do_filter() {
    setState(() {
      print("do filter");
      applys_selected = applys.where((apply) {
        String name = apply["applyer"]["first_name"].toString().toLowerCase();
        String search_name = _name.text.trim().toLowerCase();

        if (name.contains(search_name)) {
          return true;
        }
        return false;
      }).toList();
      print(applys_selected);
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Column(
                  children: [
                    Text('Search theo tên : '),
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.greenAccent), //<-- SEE HERE
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.greenAccent), //<-- SEE HERE
                        ),
                      ),
                      onChanged: (text) {
                        do_filter();
                      },
                    ),
                    (applys_selected.length == 0)
                        ? Text('Danh sách rỗng')
                        : SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return ApplyInBookItem(
                                  apply: applys_selected[index],
                                  reload: init,
                                );
                              },
                              itemCount: applys_selected.length,
                            ),
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
