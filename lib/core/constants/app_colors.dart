import 'package:flutter/material.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';

class AppColors {
  const AppColors._();

  static const Color primary = AppTheme.primary;
  static const Color primaryLight = AppTheme.primary;
  static const Color primaryDark = Color(0xFF0754E8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color background = Color(0xFFF6F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF172033);
  static const Color textSecondary = Color(0xFF667085);
  static const Color border = Color(0xFFC7D0DE);
  static const Color success = Color(0xFF20A464);
  static const Color warning = Color(0xFFE7A23B);
  static const Color error = Color(0xFFE04F5F);
}
