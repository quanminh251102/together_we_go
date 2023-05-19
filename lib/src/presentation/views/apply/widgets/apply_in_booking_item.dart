import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:rating_dialog/rating_dialog.dart';

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
      child: Column(
        children: [
          // Text(widget.apply["_id"]),
          Text(
            widget.apply["applyer"]["first_name"],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.apply["state"],
          ),

          CachedNetworkImage(
            imageUrl: widget.apply["applyer"]["avatarUrl"],
            imageBuilder: (context, imageProvider) => Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(
                        60.0) //                 <--- border radius here
                    ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
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
