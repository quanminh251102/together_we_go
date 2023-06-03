import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/handle_string.dart';
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
                    if (applys_selected.length == 0)
                      const Text('Danh sách rỗng'),
                    if (applys_selected.length > 0)
                      for (var _apply in applys_selected) ...[
                        CustomCard(
                            borderRadius: 10,
                            childPadding: 16,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: NetworkImage(
                                                _apply["booking"]["authorId"]
                                                    ["avatarUrl"]),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _apply["booking"]["authorId"]
                                                    ["first_name"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(_apply["booking"]["authorId"]
                                                  ["phoneNumber"]),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              'Giá : ${HandleString.priceInPost_noType((_apply["booking"]["price"]).toString())}'),
                                          Text(HandleString.timeDistanceFromNow(
                                              DateTime.parse(
                                                  _apply["createdAt"]))),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (_apply["state"] == 'waiting')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Material(
                                          color: Color(0xffEDF3FC),
                                          borderRadius:
                                              BorderRadius.circular(52),
                                          child: InkWell(
                                            onTap: () {},
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            child: Container(
                                              width: 109,
                                              height: 39,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(52),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Đang chờ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff5386E4),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (_apply["state"] == 'accepted')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Material(
                                          color: Color(0xffE8FDF2),
                                          borderRadius:
                                              BorderRadius.circular(52),
                                          child: InkWell(
                                            onTap: () {},
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            child: Container(
                                              width: 76,
                                              height: 39,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(52),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Chấp nhận',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0E9D57),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (_apply["state"] == 'starting')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Material(
                                          color: Color(0xffE8FDF2),
                                          borderRadius:
                                              BorderRadius.circular(52),
                                          child: InkWell(
                                            onTap: () {},
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            child: Container(
                                              width: 120,
                                              height: 39,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(52),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Đang bắt đầu',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0E9D57),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (_apply["state"] == 'close')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Material(
                                          color: Color(0xffE8FDF2),
                                          borderRadius:
                                              BorderRadius.circular(52),
                                          child: InkWell(
                                            onTap: () {},
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            child: Container(
                                              width: 76,
                                              height: 39,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(52),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Đã đóng',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0E9D57),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (_apply["state"] == 'refuse')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Material(
                                            color: Color(0xffFFEDED),
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            child: InkWell(
                                              onTap: () {},
                                              borderRadius:
                                                  BorderRadius.circular(52),
                                              child: Container(
                                                width: 80,
                                                height: 39,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(52),
                                                ),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Bị từ chối',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xffDC312D),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Thông tin bài post",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Điểm đi: ${_apply["booking"]["startPointAddress"]}"),
                                  Text(
                                      "Điểm đến: ${_apply["booking"]["endPointAddress"]}"),
                                  if (_apply["state"] == "starting") ...[
                                    // Text(
                                    //     'Tọa độ của người đăng : ${applys_selected[index]["booking"]["authorId"]["first_name"]}'),
                                    // Text(
                                    //     'id : ${applys_selected[index]["booking"]["authorId"]["location_id"]}'),
                                    // Text(
                                    //     'main text : $applys_selected[index]["booking"]["authorId"]["location_mainText"]}'),
                                    // Text(
                                    //     'adrress : ${applys_selected[index]["booking"]["authorId"]["location_address"]}'),
                                    // Text(
                                    //     'Tọa độ của người apply : ${applys_selected[index]["applyer"]["first_name"]}'),
                                    // Text(
                                    //     'id : ${applys_selected[index]["applyer"]["location_id"]}'),
                                    // Text(
                                    //     'main text : ${applys_selected[index]["applyer"]["location_mainText"]}'),
                                    // Text(
                                    //     'adrress : ${applys_selected[index]["applyer"]["location_address"]}'),
                                  ]
                                ])),
                        const SizedBox(height: 12),
                      ],
                  ],
                ),
              ),
            ),
    );
  }
}
