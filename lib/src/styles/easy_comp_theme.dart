import 'package:easy_comp/src/styles/easy_comp_colors.dart';
import 'package:easy_comp/src/styles/easy_comp_styles.dart';
import 'package:easy_comp/src/styles/easy_comp_text.dart';
import 'package:flutter/material.dart';

class EasyCompTheme {
  static EasyCompTheme? _instance;

  EasyCompTheme._();

  static EasyCompTheme get i {
    _instance ??= EasyCompTheme._();
    return _instance!;
  }

  static InputBorder defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(
      color: Colors.grey[400]!,
    ),
  );

  ThemeData get themeData => ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: EasyCompColors.i.primary,
          primary: EasyCompColors.i.primary,
          secondary: EasyCompColors.i.secundary,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          //backgroundColor: Colors.white,
          backgroundColor: EasyCompColors.i.primary,
          elevation: 2,
          centerTitle: true,
          //iconTheme: IconThemeData(color: Colors.grey[900]),
          //foregroundColor: Colors.grey[900],
        ),
        primaryColor: EasyCompColors.i.primary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: EasyCompStyles.i.primaryButton,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          labelStyle: EasyCompText.i.textRegular.copyWith(color: Colors.grey[900]),
          errorStyle: EasyCompText.i.textRegular.copyWith(color: Colors.redAccent),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: EasyCompColors.i.primary,
          foregroundColor: Colors.white,
        ),
      );
}

extension EasyCompThemeExtensions on BuildContext {
  EasyCompTheme get themeConfig => EasyCompTheme.i;
}
