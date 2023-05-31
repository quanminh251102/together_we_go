import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../../utils/constants/colors.dart';
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
  List<dynamic> reviews_selected = [];
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
      isLoading = true;
    });

    String result = "pass";

    try {
      reviews = await ReviewService.getReviewWithUserId(appUser.id);
      reviews_selected = reviews;
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

  void do_filter() {
    setState(() {
      print("do filter");
      print(_name.text.trim().toLowerCase());
      reviews_selected = reviews.where((review) {
        String name = review["creater"]["first_name"].toString().toLowerCase();
        String search_name = _name.text.trim().toLowerCase();

        if (name.contains(search_name)) {
          return true;
        }
        return false;
      }).toList();
      print(reviews_selected);
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
      appBar: AppBar(
        title: Text('Đánh giá đến tôi'),
        centerTitle: true,
      ),
      body: isLoading
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
                    (reviews_selected.length == 0)
                        ? Text('Danh sách rỗng')
                        : SizedBox(
                            height: 600,
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return CustomCard(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: NetworkImage(
                                            reviews_selected[index]["creater"]
                                                ["avatarUrl"]),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      Text(
                                          'Người đánh giá : ${reviews_selected[index]["creater"]["first_name"]}'),
                                      Text(
                                          'Số sao : ${reviews_selected[index]["review_star"]}'),
                                      Text(
                                          'Lời đánh giá : ${reviews_selected[index]["review_note"]}')
                                    ],
                                  ),
                                );
                              },
                              itemCount: reviews_selected.length,
                            ),
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
