import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../services/apply.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading_waiting_accpected = false;
    isLoading_waiting_rejected = false;
    isLoading_accepted_start = false;
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

  void accepted_start() async {
    setState(() {
      isLoading_accepted_start = true;
    });
    await Future.delayed(Duration(seconds: 2));
    // String result = await ApplyService.update(widget.apply["_id"], {
    //   "state": "accepted",
    // });
    // if (result == "pass") {
    //   widget.reload();
    // }
    // else {
    //    const snackBar = SnackBar(
    //     content: Text('Bị lổi'),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
    setState(() {
      isLoading_accepted_start = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Text(widget.apply["_id"]),
          Text(widget.apply["state"]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isLoading_waiting_accpected ||
                  isLoading_waiting_rejected ||
                  isLoading_accepted_start)
                CircularProgressIndicator(),
              if (!(isLoading_waiting_accpected ||
                  isLoading_waiting_rejected ||
                  isLoading_accepted_start)) ...[
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
                      child: Text('Đóng')),
                ],
                if (widget.apply["state"] == "accepted") ...[
                  ElevatedButton(
                      onPressed: () {
                        waiting_rejected();
                      },
                      child: Text('Bắt đầu')),
                ],
              ],
            ],
          )
        ],
      ),
    );
  }
}
