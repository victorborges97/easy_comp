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

1. Inclue BaseWidget
2. Inclue BasefulWidget

## Instalação

1. Adicione a ultima versão ao arquivo pubspec.yaml (e rode 'dart pub get');
```yaml
dependencies:
  easy_comp: ^0.0.1
```

2. Importe o pacote para usar no seu App Flutter
```dart
import 'package:easy_comp/easy_comp.dart';
```

## Usage

* Usando componente StatelessWidget
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

* Usando componente StatefulWidget
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

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
