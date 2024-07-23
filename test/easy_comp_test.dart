import 'package:easy_comp/easy_comp.dart';
import 'package:flutter/material.dart';

void main() {
  configStyles(
    primaryColor: Colors.redAccent,
  );

  runApp(
    MaterialApp(
      theme: EasyCompTheme.i.themeData,
      home: const Text("TESTE"),
    ),
  );
}
