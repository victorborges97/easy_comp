import 'package:easy_comp/src/styles/app_colors.dart';
import 'package:easy_comp/src/styles/app_text.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static AppStyles? _instance;

  AppStyles._();

  static AppStyles get i {
    _instance ??= AppStyles._();
    return _instance!;
  }

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        backgroundColor: AppColors.i.primary,
        textStyle: AppText.i.textButtonLabel,
        foregroundColor: Colors.white,
      );
}

extension AppStylesExtensions on BuildContext {
  AppStyles get stylesApp => AppStyles.i;
}
