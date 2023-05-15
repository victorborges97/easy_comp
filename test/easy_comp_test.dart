import 'package:easy_comp/easy_comp.dart';
import 'package:flutter/material.dart';

void main() {}

class EasyCompTeste extends BaseWidget {
  EasyCompTeste({super.key});

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
