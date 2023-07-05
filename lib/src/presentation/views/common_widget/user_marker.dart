import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class UserMarker extends StatefulWidget {
  const UserMarker({Key? key}) : super(key: key);

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    sizeAnimation = Tween<double>(
      begin: 45,
      end: 60,
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.person_pin,
        color: Colors.black,
        size: 35,
      ),
    );
  }
}
