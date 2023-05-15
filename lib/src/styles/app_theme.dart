import 'package:easy_comp/src/styles/app_colors.dart';
import 'package:easy_comp/src/styles/app_styles.dart';
import 'package:easy_comp/src/styles/app_text.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static AppTheme? _instance;

  AppTheme._();

  static AppTheme get i {
    _instance ??= AppTheme._();
    return _instance!;
  }

  static final _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(
      color: Colors.grey[400]!,
    ),
  );

  ThemeData get themeData => ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.i.primary,
          primary: AppColors.i.primary,
          secondary: AppColors.i.secundary,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          //backgroundColor: Colors.white,
          backgroundColor: AppColors.i.primary,
          elevation: 2,
          centerTitle: true,
          //iconTheme: IconThemeData(color: Colors.grey[900]),
          //foregroundColor: Colors.grey[900],
        ),
        primaryColor: AppColors.i.primary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.i.primaryButton,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.all(13),
          border: _defaultInputBorder,
          enabledBorder: _defaultInputBorder,
          focusedBorder: _defaultInputBorder,
          labelStyle: AppText.i.textRegular.copyWith(color: Colors.grey[900]),
          errorStyle: AppText.i.textRegular.copyWith(color: Colors.redAccent),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.i.primary,
          foregroundColor: Colors.white,
        ),
      );
}

extension AppThemeExtensions on BuildContext {
  AppTheme get themeConfig => AppTheme.i;
}
