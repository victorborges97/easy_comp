import 'package:flutter/material.dart';

class EasyCompColors {
  static Color primaryDefault = const Color(0xFF00436F);
  static Color secundaryDefault = const Color(0xFF6B6B6B);
  static EasyCompColors? _instance;

  EasyCompColors._();

  static EasyCompColors get i {
    _instance ??= EasyCompColors._();
    return _instance!;
  }

  Color get primary => primaryDefault;
  Color get secundary => secundaryDefault;
}

extension EasyCompColorsExtensions on BuildContext {
  EasyCompColors get colors => EasyCompColors.i;
}
