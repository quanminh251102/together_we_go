import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:together_we_go/src/presentation/views/apply/widgets/apply_in_booking_item.dart';

import '../../../utils/constants/colors.dart';
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
  late FocusNode nameFocus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameFocus = FocusNode();

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
    search_bar() {
      return [
        Text('Search theo tên : '),
        TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w600),
          focusNode: nameFocus,
          controller: _name,
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
            filled: true, //<-- SEE HERE
            fillColor: nameFocus.hasFocus
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 2.0,
              ),
            ),
            hintText: 'Tìm kiếm',
            // prefixIcon: Icon(
            //   Icons.email_outlined,
            //   color: nameFocus.hasFocus ? AppColors.primaryColor : Colors.black,
            // ),
          ),
          onChanged: (text) {
            do_filter();
          },
        ),
      ];
    }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...search_bar(),
                    const SizedBox(height: 20),
                    (applys_selected.length == 0)
                        ? Text('Danh sách rỗng')
                        : SizedBox(
                            height: 500,
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
