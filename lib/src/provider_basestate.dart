import 'dart:developer';

import 'package:flutter/cupertino.dart';

class ProviderBaseState extends ChangeNotifier {
  String titulo = "";

  Future<List<String>> getDadosApi() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return ["Teste", "Recuperado"];
    } catch (e, s) {
      log("Error ao recuperar", error: e, stackTrace: s);
      return [];
    }
  }
}
