import 'package:flutter/material.dart';

class AppText {
  static AppText? _instance;

  AppText._();

  static AppText get i {
    _instance ??= AppText._();
    return _instance!;
  }

  String get font => 'Roboto';

  TextStyle get textLight => TextStyle(fontFamily: font, fontWeight: FontWeight.w300, color: Colors.grey[900]);

  TextStyle get textRegular => TextStyle(fontFamily: font, fontWeight: FontWeight.normal, color: Colors.grey[900]);

  TextStyle get textMedium => TextStyle(fontFamily: font, fontWeight: FontWeight.w500, color: Colors.grey[900]);

  TextStyle get textSemiBold => TextStyle(fontFamily: font, fontWeight: FontWeight.w600, color: Colors.grey[900]);

  TextStyle get textBold => TextStyle(fontFamily: font, fontWeight: FontWeight.bold, color: Colors.grey[900]);

  TextStyle get textExtraBold => TextStyle(fontFamily: font, fontWeight: FontWeight.w800, color: Colors.grey[900]);

  TextStyle get textButtonLabel => textBold.copyWith(fontSize: 14, color: Colors.grey[900]);

  TextStyle get textTitle => textExtraBold.copyWith(fontSize: 28, color: Colors.grey[900]);
}

extension AppTextExtensions on BuildContext {
  AppText get textApp => AppText.i;
}
