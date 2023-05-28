import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                    Text('Điểm đi : '),
                    TextField(
                      controller: _startPoint,
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
                    Text('Điểm đến : '),
                    TextField(
                      controller: _endPoint,
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
                    SizedBox(
                      height: 20,
                    ),
                    (applys_selected.length == 0)
                        ? const Text('Danh sách rỗng')
                        : SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return Card(
                                    child: Column(
                                  children: [
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
                                        "Đã apply vào ${applys_selected[index]["createdAt"]}")
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
