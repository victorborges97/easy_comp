import 'package:easy_comp/src/styles/easy_comp_colors.dart';
import 'package:easy_comp/src/styles/easy_comp_text.dart';
import 'package:flutter/material.dart';

class EasyCompStyles {
  static EasyCompStyles? _instance;

  EasyCompStyles._();

  static EasyCompStyles get i {
    _instance ??= EasyCompStyles._();
    return _instance!;
  }

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        backgroundColor: EasyCompColors.i.primary,
        textStyle: EasyCompText.i.textButtonLabel,
        foregroundColor: Colors.white,
      );
}

extension EasyCompStylesExtensions on BuildContext {
  EasyCompStyles get stylesApp => EasyCompStyles.i;
}
