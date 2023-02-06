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

## Features

1. BaseWidget
2. BasefulWidget
3. BaseState
4. ValidatorUtil

## Instalação

1. Adicione a ultima versão ao arquivo pubspec.yaml (e rode 'dart pub get');

```yaml
dependencies:
    easy_comp: ^0.0.2
```

2. Importe o pacote para usar no seu App Flutter

```dart
import 'package:easy_comp/easy_comp.dart';
```

## Usage

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
import 'package:easy_comp/src/base_state.dart';
import 'package:easy_comp/src/provider_basestate.dart';
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
```
