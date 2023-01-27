import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  final Function(T? builder) builder;
  final Stream<T>? stream;
  final Widget? erroWidget;
  final Widget? loadingWidget;
  const CustomStreamBuilder(
      {Key? key,
        required this.builder,
        this.erroWidget,
        this.loadingWidget,
        this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, future) {
        if (future.hasError) {
          return erroWidget ?? Center(child: Text(future.error.toString()));
        }

        if (future.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              );
        }

        return builder(future.data);
      },
    );
  }
}
