import 'package:easy_comp/easy_comp.dart';
import 'package:flutter/material.dart';

class TestePage extends BaseWidget {
  TestePage({super.key});
  @override
  Widget builder(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestePage'),
      ),
      body: const Text('TestePage'),
    );
  }
}
