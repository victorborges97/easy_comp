<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Componentes

1. BaseWidget
2. BasefulWidget
3. BaseState
4. ValidatorUtil
5. FirebaseFirestoreRepository
6. CustomFuture

## Instalação

1. Adicione a ultima versão ao arquivo pubspec.yaml (e rode 'dart pub get');

```yaml
dependencies:
    easy_comp: ^0.0.10
```

2. Importe o pacote para usar no seu App Flutter

```dart
import 'package:easy_comp/easy_comp.dart';
```

## Modo de usar

-   Usando componente BaseWidget em um StatelessWidget

```dart
import 'package:flutter/material.dart';
import 'package:easy_comp/easy_comp.dart';

class EasyCompTeste extends BaseWidget {
  EasyCompTeste({Key? key});

  @override
  Widget builder(BuildContext context, BoxConstraints constrains) {
    return Container(
      child: Center(
        child: Text("Usando BaseWidget"),
      ),
    );
  }
}
```

-   Usando componente BasefulWidget em um StatefulWidget

```dart
import 'package:flutter/material.dart';
import 'package:easy_comp/easy_comp.dart';

class EasyCompTeste extends BasefulWidget {
  EasyCompTeste({Key? key});
  @override
  _EasyCompTesteState createState() => _EasyCompTesteState();
}

class _EasyCompTesteState extends BasefulWidgetState<EasyCompTeste> {
  @override
  Widget builder(BuildContext context, BoxConstraints constrains) {
    return Container(
      child: Center(
        child: Text("Usando BaseWidgetFull"),
      ),
    );
  }
}
```

-   Usando componente BaseState em um StatefulWidget

```dart
import 'package:easy_comp/easy_comp.dart';
import 'package:easy_comp/src/testes/provider_basestate.dart';
import 'package:flutter/material.dart';

class TesteBaseState extends StatefulWidget {
  const TesteBaseState({super.key});
  @override
  BaseState<TesteBaseState, ProviderBaseState> createState() => _TesteBaseStateState();
}

class _TesteBaseStateState extends BaseState<TesteBaseState, ProviderBaseState> {

  @override
  void onInit() {
    super.onInit();
    debugPrint(provider.titulo);

    provider.titulo = "Mudando";
  }

  @override
  void onResume() {
    super.onResume();
    provider.getDadosApi();
  }

  @override
  Widget build(BuildContext context) {
    return Text(provider.titulo);
  }
}
```

-   Usando componente FirebaseFirestoreRepository

```dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comp/easy_comp.dart';
import 'package:easy_comp/src/utils/utils.dart';

class TesteModel {
  String id = "";
  String nome = "";
  String categoria = "INITIAL";
  TesteModel({
    required this.id,
    required this.nome,
    this.categoria = "INITIAL",
  });

  TesteModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    id = getMap<String>(key: "id", map: map, retur: doc.id);
    nome = getMap<String>(key: "nome", map: map, retur: "");
    categoria = getMap<String>(key: "categoria", map: map, retur: "INITIAL");
  }

  TesteModel.fromJson(Map<String, dynamic> map, String? id) {
    this.id = id ?? (getMap<String>(key: "id", map: map, retur: ""));
    nome = getMap<String>(key: "nome", map: map, retur: "");
    categoria = getMap<String>(key: "categoria", map: map, retur: "INITIAL");
  }

  static Map<String, dynamic> toJson(TesteModel model) => {
        "id": model.id,
        "nome": model.nome,
        "categoria": model.categoria,
      };

  @override
  String toString() => 'Teste(id: $id, nome: $nome, categoria: $categoria)\n';
}

class TesteRepository extends FirebaseFirestoreRepository<TesteModel> {
  TesteRepository()
      : super(
          collectionPath: 'BAIRROS',
          firestore: FirebaseFirestore.instance,
          fromJson: TesteModel.fromJson,
          toJson: TesteModel.toJson,
        );

  @override
  CollectionReference<TesteModel> get collection => super.collection;

  Future<List<TesteModel>> todosByCategoria() async {
    final lista = await collection.where("categoria", isEqualTo: "INITIAL").get().then((value) => value.docs.map((e) => e.data()).toList());
    return lista;
  }
}

void main() async {
  final repo = TesteRepository();
  final todos = await repo.buscarTodos(
    descending: false,
    limit: 10,
    orderBy: "nome",
    where: QueryConstraint(field: "categoria", op: QueryOperation.isEqualTo, value: "INITIAL"),
    // Ou
    whereList: [
      QueryConstraint(field: "categoria", op: QueryOperation.isEqualTo, value: "INITIAL"),
      QueryConstraint(field: "nome", op: QueryOperation.isGreaterThanOrEqualTo, value: "Teste"),
    ],
  );
  log(todos.toString());
}
```

-   Usando componente CustomFuture

```dart
import 'package:flutter/material.dart';
import 'package:easy_comp/easy_comp.dart';

class EasyCompTeste extends BaseWidget {
  EasyCompTeste({Key? key});

  Future<List<String>> getValues() async {
    await Future.delayed(const Duration(seconds: 2));
    return ["1", "2", "3"];
  }

  @override
  Widget builder(BuildContext context, BoxConstraints constrains) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste"),
      ),
      body: CustomFuture<List<String>>(
        future: getValues(),
        emptyWidget: const Text("Empty"),
        withLoading: true,
        withError: true,
        erroBuilder: (error) {
          return Text(error.toString());
        },
        builder: (values) {
          return ListView.builder(
            itemCount: values.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(values[index]),
              );
            },
          );
        },
      ),
    );
  }
}
```

-   Usando componentes de thema junto com Widgets do EasyComp

```dart
import 'package:flutter/material.dart';
import 'package:easy_comp/easy_comp.dart';

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
```