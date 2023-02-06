import 'package:easy_comp/src/base_state.dart';
import 'package:easy_comp/src/testes/provider_basestate.dart';
import 'package:flutter/material.dart';

class TesteBaseState extends StatefulWidget {
  const TesteBaseState({super.key});
  @override
  BaseState<TesteBaseState, ProviderBaseState> createState() => _TesteBaseStateState();
}

class _TesteBaseStateState extends BaseState<TesteBaseState, ProviderBaseState> {
  // Contem a variavel provider para pegar os dados do ProviderBaseState;

  @override
  void onInit() {
    // onInit é o InitState
    super.onInit();
    debugPrint(provider.titulo);

    provider.titulo = "Mudando";
  }

  @override
  void onResume() {
    // onResume é após o carregamendo da tela para buscar no servidor...
    super.onResume();
    provider.getDadosApi();
  }

  @override
  Widget build(BuildContext context) {
    return Text(provider.titulo);
  }
}
