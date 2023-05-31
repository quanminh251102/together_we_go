import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../utils/constants/colors.dart';
import '../../services/apply.dart';

class MyApplyPage extends StatefulWidget {
  const MyApplyPage({super.key});

  @override
  State<MyApplyPage> createState() => _MyApplyPageState();
}

class _MyApplyPageState extends State<MyApplyPage> {
  bool isLoading_getMyApply = false;
  List<dynamic> applys = [];
  List<dynamic> applys_selected = [];
  TextEditingController _startPoint = TextEditingController();
  TextEditingController _endPoint = TextEditingController();
  late FocusNode startPointFocus;
  late FocusNode endPointFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startPointFocus = FocusNode();
    endPointFocus = FocusNode();

    init();
  }

  void init() async {
    setState(() {
      isLoading_getMyApply = true;
    });

    String result = "pass";

    try {
      applys = await ApplyService.getMyApply();
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
      isLoading_getMyApply = false;
    });
  }

  void do_filter() {
    setState(() {
      print("do filter");
      applys_selected = applys.where((apply) {
        String booking_startPoint =
            apply["booking"]["startPointMainText"].toString().toLowerCase() +
                apply["booking"]["startPointAddress"].toString().toLowerCase();
        String booking_endPoint =
            apply["booking"]["endPointMainText"].toString().toLowerCase() +
                apply["booking"]["endPointAddress"].toString().toLowerCase();
        String search_startPoint = _startPoint.text.trim().toLowerCase();
        String search_endPoint = _endPoint.text.trim().toLowerCase();

        if (booking_startPoint.contains(search_startPoint) &&
            booking_endPoint.contains(search_endPoint)) {
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
        Text('Điểm đi : '),
        TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w600),
          focusNode: startPointFocus,
          controller: _startPoint,
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
            filled: true, //<-- SEE HERE
            fillColor: startPointFocus.hasFocus
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
            hintText: 'Điểm đi',
            prefixIcon: Icon(
              Icons.location_on,
              color: startPointFocus.hasFocus
                  ? AppColors.primaryColor
                  : Colors.black,
            ),
          ),
          onChanged: (text) {
            do_filter();
          },
        ),
        Text('Điểm đến : '),
        TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w600),
          focusNode: endPointFocus,
          controller: _endPoint,
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
            filled: true, //<-- SEE HERE
            fillColor: endPointFocus.hasFocus
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
            hintText: 'Điểm đến',
            prefixIcon: Icon(
              Icons.location_on,
              color: endPointFocus.hasFocus
                  ? AppColors.primaryColor
                  : Colors.black,
            ),
          ),
          onChanged: (text) {
            do_filter();
          },
        ),
        SizedBox(
          height: 20,
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply của tôi'),
        centerTitle: true,
      ),
      body: isLoading_getMyApply
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...search_bar(),
                    (applys_selected.length == 0)
                        ? const Text('Danh sách rỗng')
                        : SizedBox(
                            height: 700,
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                var _apply = applys_selected[index];
                                return Card(
                                    child: Column(
                                  children: [
                                    Text(
                                        'state : ${applys_selected[index]["state"]}'),
                                    Text("Thông tin bài post"),
                                    Text(
                                        "Điểm đi: ${applys_selected[index]["booking"]["startPointAddress"]}"),
                                    Text(
                                        "Điểm đến: ${applys_selected[index]["booking"]["endPointAddress"]}"),
                                    Text("avatar của người đăng booking :"),
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          applys_selected[index]["booking"]
                                              ["authorId"]["avatarUrl"]),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Text(
                                        "Đã apply vào ${applys_selected[index]["createdAt"]}"),
                                    if (_apply["state"] == "starting") ...[
                                      Text(
                                          'Tọa độ của người đăng : ${_apply["booking"]["authorId"]["first_name"]}'),
                                      Text(
                                          'id : ${_apply["booking"]["authorId"]["location_id"]}'),
                                      Text(
                                          'main text : ${_apply["booking"]["authorId"]["location_mainText"]}'),
                                      Text(
                                          'adrress : ${_apply["booking"]["authorId"]["location_address"]}'),
                                      Text(
                                          'Tọa độ của người apply : ${_apply["applyer"]["first_name"]}'),
                                      Text(
                                          'id : ${_apply["applyer"]["location_id"]}'),
                                      Text(
                                          'main text : ${_apply["applyer"]["location_mainText"]}'),
                                      Text(
                                          'adrress : ${_apply["applyer"]["location_address"]}'),
                                    ],
                                  ],
                                ));
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
