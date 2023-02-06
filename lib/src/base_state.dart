// import 'package:bloc/bloc.dart';
import 'package:easy_comp/src/loader.dart';
import 'package:easy_comp/src/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseState<T extends StatefulWidget, C extends ChangeNotifier> extends State<T> with Loader, Messages {
  late final C provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<C>();
    onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onResume();
    });
  }

  void onInit() {}

  void onResume() {}
}
