import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(elevation: 0, color: Colors.white),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primaryColor,
      splashColor: Colors.transparent,
      fontFamily: 'AvertaStd',
      colorScheme:
          ThemeData().colorScheme.copyWith(primary: AppColors.primaryColor),
    );
  }
}
