import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../cubits/app_user.dart';
import '../../../services/review.dart';

class MyReViewsPage extends StatefulWidget {
  const MyReViewsPage({super.key});

  @override
  State<MyReViewsPage> createState() => _MyReViewsPageState();
}

class _MyReViewsPageState extends State<MyReViewsPage> {
  bool isLoading = false;
  List<dynamic> reviews = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });

    String result = "pass";

    try {
      reviews = await ReviewService.getReviewWithUserId(appUser.id);
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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá đến tôi'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                children: [
                  (reviews.length == 0)
                      ? Text('Danh sách rỗng')
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return CustomCard(
                                child: Column(
                                  children: [
                                    Text(
                                        'Người đánh giá : ${reviews[index]["creater"]["first_name"]}'),
                                    Text(
                                        'Số sao : ${reviews[index]["review_star"]}'),
                                    Text(
                                        'Lời đánh giá : ${reviews[index]["review_note"]}')
                                  ],
                                ),
                              );
                            },
                            itemCount: reviews.length,
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
