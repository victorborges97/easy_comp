import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  final Function(T? builder) builder;
  final Stream<T>? stream;
  final bool withLoading;
  final bool withError;
  final Widget? erroWidget;
  final Widget Function(Object?)? erroBuilder;
  final Widget? loadingWidget;
  final Widget Function()? loadingBuilder;
  final Widget? emptyWidget;

  const CustomStreamBuilder({
    Key? key,
    required this.builder,
    this.erroWidget,
    this.loadingWidget,
    this.stream,
    this.withLoading = false,
    this.withError = false,
    this.erroBuilder,
    this.loadingBuilder,
    this.emptyWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, future) {
        if (withError && future.hasError) {
          return erroBuilder != null ? erroBuilder!(future.error) : erroWidget ?? Center(child: Text(future.error.toString()));
        }

        if (withLoading && future.connectionState == ConnectionState.waiting) {
          return loadingBuilder != null
              ? loadingBuilder!()
              : loadingWidget ??
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
        }

        if ((future.data is List) && (future.data as List).isEmpty && emptyWidget != null) return emptyWidget!;

        return builder(future.data);
      },
    );
  }
}
