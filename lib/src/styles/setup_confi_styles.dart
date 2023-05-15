import 'dart:developer';

import 'package:easy_comp/src/styles/easy_comp_colors.dart';
import 'package:easy_comp/src/styles/easy_comp_text.dart';
import 'package:easy_comp/src/styles/easy_comp_theme.dart';
import 'package:flutter/material.dart';

void configStyles({
  InputBorder? inputBorder,
  String? fontFamily,
  Color? primaryColor,
  Color? secundaryColor,
}) {
  log("CONFIG_STYLES_EASYCOMP");
  if (inputBorder != null) EasyCompTheme.defaultInputBorder = inputBorder;
  if (fontFamily != null) EasyCompText.fontFamily = fontFamily;
  if (primaryColor != null) EasyCompColors.primaryDefault = primaryColor;
  if (secundaryColor != null) EasyCompColors.secundaryDefault = secundaryColor;
}
