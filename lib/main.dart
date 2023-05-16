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
  EasyCompTeste({Key? key});
  @override
  Widget builder(BuildContext context, BoxConstraints constrains) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste"),
      ),
      body: Column(
        children: [
          Text(
            "Estilizando de acordo com o thema",
            style: context.textApp.textBold.copyWith(
              fontSize: 25,
              color: context.colors.primary,
            ),
          ),
          EasyCompInputCalendar(
            onChange: (data) {
              print(data);
            },
          ),
          const SizedBox(height: 30),
          EasyCompInputCalendar.multiplos(
            labelText: "Date Range",
            onChange: (data1, data2) {
              print(data1);
              print(data2);
            },
          ),
          const SizedBox(height: 30),
          EasyCompInput(
            labelText: "Input text",
            onChange: (data1) {
              print(data1);
            },
            icon: Icon(Icons.search),
          ),
          const SizedBox(height: 10),
          EasyCompInput(
            labelText: "Input password",
            isPassword: true,
            onChange: (data1) {
              print(data1);
            },
            validator: (v) {},
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EasyCompInput(
                  labelText: "Input cpfOrCnpj",
                  typeInput: EasyCompInputType.cpfOrCnpj,
                  onChange: (data1) {
                    print(data1);
                  },
                  validator: (v) {},
                  withValidation: true,
                  icon: Icon(Icons.search),
                ),
              ),
              Expanded(
                child: EasyCompInput(
                  labelText: "Input cpfOrCnpj",
                  typeInput: EasyCompInputType.cpfOrCnpj,
                  onChange: (data1) {
                    print(data1);
                  },
                  validator: (v) {},
                  withValidation: true,
                ),
              ),
              EasyCompButton(
                width: 50,
                height: 35,
                child: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          EasyCompInput.future(
            labelText: "Input cep",
            typeInput: EasyCompInputType.cep,
            onChange: (data1) {
              print(data1);
            },
            validator: ValidatorUtil(isFuture: true).required().custom(
              future: (value) async {
                Utils.delay(3);
                return true;
              },
            ).buildFuture(),
            withValidation: true,
          ),
          const SizedBox(height: 10),
          EasyCompInput.future(
            labelText: "Input cpf",
            typeInput: EasyCompInputType.cpf,
            onChange: (data1) {
              print(data1);
            },
          )
        ],
      ),
    );
  }
}
