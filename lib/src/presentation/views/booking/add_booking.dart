import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/colors.dart';

class NewBookingView extends StatefulWidget {
  const NewBookingView({super.key});

  @override
  State<NewBookingView> createState() => _NewBookingViewState();
}

class _NewBookingViewState extends State<NewBookingView> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => appRouter.pop(),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
          ),
        ),
        title: const Text(
          'ĐĂNG BÀI',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại bài đăng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                height: screenSize.width * 0.3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
