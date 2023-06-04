import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../../../utils/handle_string.dart';
import '../../../cubits/app_user.dart';
import '../../../services/apply.dart';
import '../../../services/review.dart';

class ApplyInBookItem extends StatefulWidget {
  final dynamic apply;
  final Function reload;
  const ApplyInBookItem({super.key, required this.apply, required this.reload});

  @override
  State<ApplyInBookItem> createState() => _ApplyInBookItemState();
}

class _ApplyInBookItemState extends State<ApplyInBookItem> {
  bool isLoading_waiting_accpected = false;
  bool isLoading_waiting_rejected = false;
  bool isLoading_accepted_start = false;
  bool isLoading_accepted_close = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.apply);
    isLoading_waiting_accpected = false;
    isLoading_waiting_rejected = false;
    isLoading_accepted_start = false;
    isLoading_accepted_close = false;
  }

  void waiting_accpected() async {
    setState(() {
      isLoading_waiting_accpected = true;
    });
    //await Future.delayed(Duration(seconds: 2));
    String result = await ApplyService.update(widget.apply["_id"], {
      "state": "accepted",
    });
    if (result == "pass") {
      widget.reload();
    } else {
      const snackBar = SnackBar(
        content: Text('Bị lổi'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading_waiting_accpected = false;
    });
  }

  void waiting_rejected() async {
    setState(() {
      isLoading_waiting_rejected = true;
    });
    // await Future.delayed(Duration(seconds: 2));
    String result = await ApplyService.update(widget.apply["_id"], {
      "state": "refuse",
    });
    if (result == "pass") {
      widget.reload();
    } else {
      const snackBar = SnackBar(
        content: Text('Bị lổi'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading_waiting_rejected = false;
    });
  }

  void accepted_starting() async {
    setState(() {
      isLoading_accepted_start = true;
    });
    // await Future.delayed(Duration(seconds: 2));
    String result = await ApplyService.update(widget.apply["_id"], {
      "state": "starting",
    });
    if (result == "pass") {
      widget.reload();
    } else {
      const snackBar = SnackBar(
        content: Text('Bị lổi'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading_accepted_start = false;
    });
  }

  void accepted_close() async {
    setState(() {
      isLoading_accepted_close = true;
    });
    // await Future.delayed(Duration(seconds: 2));
    String result = await ApplyService.update(widget.apply["_id"], {
      "state": "close",
    });
    if (result == "pass") {
      widget.reload();
    } else {
      const snackBar = SnackBar(
        content: Text('Bị lổi'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading_accepted_close = false;
    });
  }

  void close_review() async {
    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Đánh giá người đi chung',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Hãy chọn số sao và viết ghi chú nếu bạn muốn',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: const FlutterLogo(size: 100),
      submitButtonText: 'Gửi',
      commentHint: 'Ghi chú',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        print('rating: ${response.rating}, comment: ${response.comment}');

        // TODO: add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {}

        Map<String, dynamic> _body = {
          "creater_id": appUser.id,
          "receiver_id": widget.apply["applyer"]["_id"],
          "apply_id": widget.apply["_id"],
          "review_note": (response.comment == "") ? " " : response.comment,
          "review_star": "${response.rating}"
        };

        String result = await ReviewService.createReview(_body);

        if (result == "pass") {
          const snackBar = SnackBar(
            content: Text('Thành công'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          const snackBar = SnackBar(
            content: Text('Bị lổi'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      childPadding: 12,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                        NetworkImage(widget.apply["applyer"]["avatarUrl"]),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.apply["applyer"]["first_name"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.apply["applyer"]["phoneNumber"]),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      'Giá : ${HandleString.priceInPost_noType((widget.apply["booking"]["price"]).toString())}'),
                  Text(HandleString.timeDistanceFromNow(
                      DateTime.parse(widget.apply["createdAt"]))),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          if (widget.apply["state"] == 'waiting')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  color: Color(0xffEDF3FC),
                  borderRadius: BorderRadius.circular(52),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(52),
                    child: Container(
                      width: 109,
                      height: 39,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(52),
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
          if (widget.apply["state"] == 'accepted')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  color: Color(0xffE8FDF2),
                  borderRadius: BorderRadius.circular(52),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(52),
                    child: Container(
                      width: 76,
                      height: 39,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(52),
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
          if (widget.apply["state"] == 'starting')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  color: Color(0xffE8FDF2),
                  borderRadius: BorderRadius.circular(52),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(52),
                    child: Container(
                      width: 120,
                      height: 39,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(52),
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
          if (widget.apply["state"] == 'close')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  color: Color(0xffE8FDF2),
                  borderRadius: BorderRadius.circular(52),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(52),
                    child: Container(
                      width: 76,
                      height: 39,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(52),
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
          if (widget.apply["state"] == 'refuse')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                    color: Color(0xffFFEDED),
                    borderRadius: BorderRadius.circular(52),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(52),
                      child: Container(
                        width: 80,
                        height: 39,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(52),
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
          // Text(widget.apply["_id"]),
          if (widget.apply["state"] == "starting") ...[
            Text(
                'Tọa độ của người đăng : ${widget.apply["booking"]["authorId"]["first_name"]}'),
            Text('id : ${widget.apply["booking"]["authorId"]["location_id"]}'),
            Text(
                'main text : ${widget.apply["booking"]["authorId"]["location_mainText"]}'),
            Text(
                'adrress : ${widget.apply["booking"]["authorId"]["location_address"]}'),
            Text(
                'Tọa độ của người apply : ${widget.apply["applyer"]["first_name"]}'),
            Text('id : ${widget.apply["applyer"]["location_id"]}'),
            Text('main text : ${widget.apply["applyer"]["location_mainText"]}'),
            Text('adrress : ${widget.apply["applyer"]["location_address"]}'),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isLoading_waiting_accpected ||
                  isLoading_waiting_rejected ||
                  isLoading_accepted_start ||
                  isLoading_accepted_close)
                CircularProgressIndicator(),
              if (!(isLoading_waiting_accpected ||
                  isLoading_waiting_rejected ||
                  isLoading_accepted_start ||
                  isLoading_accepted_close)) ...[
                if (widget.apply["state"] == "waiting") ...[
                  ElevatedButton(
                      onPressed: () {
                        waiting_accpected();
                      },
                      child: Text('Đồng ý')),
                  ElevatedButton(
                      onPressed: () {
                        waiting_rejected();
                      },
                      child: Text('Từ chối')),
                ],
                if (widget.apply["state"] == "accepted") ...[
                  ElevatedButton(
                      onPressed: () {
                        accepted_starting();
                      },
                      child: Text('Bắt đầu')),
                ],
                if (widget.apply["state"] == "starting") ...[
                  ElevatedButton(
                      onPressed: () {
                        accepted_close();
                      },
                      child: Text('Đóng')),
                ],
                if (widget.apply["state"] == "close") ...[
                  ElevatedButton(
                      onPressed: () {
                        close_review();
                      },
                      child: Text('Đánh giá')),
                ],
                if (widget.apply["state"] == "refuse") ...[],
              ],
            ],
          )
        ],
      ),
    );
  }
}
