import 'package:flutter/material.dart';

class EasyCompText {
  static EasyCompText? _instance;
  static String fontFamily = "mplus1";

  EasyCompText._();

  static EasyCompText get i {
    _instance ??= EasyCompText._();
    return _instance!;
  }

  String get font => fontFamily;

  TextStyle get textLight => TextStyle(fontFamily: font, fontWeight: FontWeight.w300, color: Colors.grey[900]);

  TextStyle get textRegular => TextStyle(fontFamily: font, fontWeight: FontWeight.normal, color: Colors.grey[900]);

  TextStyle get textMedium => TextStyle(fontFamily: font, fontWeight: FontWeight.w500, color: Colors.grey[900]);

  TextStyle get textSemiBold => TextStyle(fontFamily: font, fontWeight: FontWeight.w600, color: Colors.grey[900]);

  TextStyle get textBold => TextStyle(fontFamily: font, fontWeight: FontWeight.bold, color: Colors.grey[900]);

  TextStyle get textExtraBold => TextStyle(fontFamily: font, fontWeight: FontWeight.w800, color: Colors.grey[900]);

  TextStyle get textButtonLabel => textBold.copyWith(fontSize: 14, color: Colors.grey[900]);

  TextStyle get textTitle => textExtraBold.copyWith(fontSize: 28, color: Colors.grey[900]);
}

extension ColorsAppExtensions on BuildContext {
  EasyCompText get textApp => EasyCompText.i;
}
