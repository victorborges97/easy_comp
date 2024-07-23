import 'package:easy_comp/easy_comp.dart';
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
  EasyCompTeste({super.key});
  @override
  Widget builder(BuildContext context, BoxConstraints constrains) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyCompValid"),
      ),
      body: Column(
        children: [
          EasyCompInput(
            onChange: (data) {
              //print(data);
            },
            // validator: EasyCompValid.required("Campo obrigatório"),
            // validator: EasyCompValid.cpf("CPF inválido"),
            // validator: EasyCompValid.cnpj("CNPJ inválido"),
            // validator: EasyCompValid.email("E-mail inválido"),
            // validator: EasyCompValid.maxLength(10, "Máximo 10 caracteres"),
            // validator: EasyCompValid.minLength(10, "Máximo 10 caracteres"),
            // validator: EasyCompValid.custom(
            //   valide: (value) {
            //     if(value == null) return false;
            //     return value == "123" ? true : false;
            //   },
            //   message: "Valor inválido",
            // ),
            validator: EasyCompValid.multiples([
              EasyCompValid.required("Campo obrigatório"),
              EasyCompValid.cpf("CPF inválido"),
            ]),
          ),
        ],
      ),
    );
  }
}
