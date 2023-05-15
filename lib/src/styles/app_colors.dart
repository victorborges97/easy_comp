import 'package:flutter/material.dart';

class AppColors {
  static Color primaryDefault = const Color(0xFF00436F);
  static Color secundaryDefault = const Color(0xFF6B6B6B);
  static AppColors? _instance;

  AppColors._();

  static AppColors get i {
    _instance ??= AppColors._();
    return _instance!;
  }

  Color get primary => primaryDefault;
  Color get secundary => secundaryDefault;
}

extension AppColorsExtensions on BuildContext {
  AppColors get colors => AppColors.i;
}
