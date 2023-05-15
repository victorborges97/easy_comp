import 'package:flutter/material.dart';

class CustomFuture<T> extends StatelessWidget {
  final Function(T builder) builder;
  final Future<T>? future;
  final bool withLoading;
  final bool withError;
  final Widget? erroWidget;
  final Widget Function(Object?)? erroBuilder;
  final Widget? loadingWidget;
  final Widget Function()? loadingBuilder;
  final Widget? emptyWidget;

  const CustomFuture({
    Key? key,
    required this.builder,
    this.erroWidget,
    this.loadingWidget,
    this.future,
    this.withLoading = false,
    this.withError = false,
    this.erroBuilder,
    this.loadingBuilder,
    this.emptyWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, future) {
        if (withError && future.hasError) {
          return erroBuilder != null ? erroBuilder!(future.error) : (erroWidget ?? Center(child: Text(future.error.toString())));
        }

        if (withLoading && future.connectionState == ConnectionState.waiting) {
          return loadingBuilder != null
              ? loadingBuilder!()
              : loadingWidget ??
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
        }

        if ((future.data is List) && (future.data as List).isEmpty && emptyWidget != null) {
          return emptyWidget!;
        }

        if (future.hasData) {
          return builder(future.data as T);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
