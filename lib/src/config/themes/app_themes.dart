import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        foregroundColor: Colors.black, //<-- SEE HERE
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
      primaryColor: AppColors.primaryColor,
      splashColor: Colors.transparent,
      fontFamily: 'AvertaStd',
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: Colors.white,
        dayPeriodTextColor: Colors.white,
        dayPeriodColor: AppColors.primaryColor, //Background of AM/PM.
        dialHandColor: AppColors.primaryColor,
        dialTextColor: AppColors.primaryColor,
      ),
      colorScheme:
          ThemeData().colorScheme.copyWith(primary: AppColors.primaryColor),
    );
  }
}
