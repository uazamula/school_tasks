import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_colors.dart';


class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      //  appBarTheme: AppBarTheme(backgroundColor: Colors.green,)
    );
  }
}