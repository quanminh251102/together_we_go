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
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                children: [
                  (applys.length == 0)
                      ? const Text('Danh sách rỗng')
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Card(
                                  child: Row(
                                children: [
                                  CircleAvatar(),
                                  Column(
                                    children: [Text(applys[index][''])],
                                  )
                                ],
                              ));
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
