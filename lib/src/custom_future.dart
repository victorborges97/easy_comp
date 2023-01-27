import 'package:flutter/material.dart';

class CustomFuture<T> extends StatelessWidget {
  final Function(T? builder) builder;
  final Future<T>? future;
  final Widget? erroWidget;
  final Widget? loadingWidget;

  const CustomFuture(
      {Key? key,
        required this.builder,
        this.erroWidget,
        this.loadingWidget,
        this.future})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, future) {
        if (future.hasError) {
          return erroWidget ?? Center(child: Text(future.error.toString()));
        }

        if (future.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
        }

        return builder(future.data);
      },
    );
  }
}
