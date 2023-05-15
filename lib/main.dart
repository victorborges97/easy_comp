import 'package:easy_comp/easy_comp.dart';
import 'package:easy_comp/src/styles/easy_comp_theme.dart';
import 'package:easy_comp/src/styles/setup_confi_styles.dart';
import 'package:easy_comp/src/widgets/input_calendar.dart';
import 'package:flutter/material.dart';

void main() {
  configStyles(
    primaryColor: Colors.redAccent,
  );

  runApp(
    MaterialApp(
      theme: EasyCompTheme.i.themeData,
      home: EasyCompTeste(),
    ),
  );
}

class EasyCompTeste extends BaseWidget {
  EasyCompTeste({Key? key});
  @override
  Widget builder(BuildContext context, BoxConstraints constrains) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste"),
      ),
      body: Column(
        children: [
          InputCalendar(
            onChange: (data) {
              print(data);
            },
          ),
          const SizedBox(height: 30),
          InputCalendar.multiplos(
            labelText: "Date Range",
            onChange: (data1, data2) {
              print(data1);
              print(data2);
            },
          ),
        ],
      ),
    );
  }
}
