// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

//StatefulWidget
abstract class BasefulWidget extends StatefulWidget {
  BasefulWidget({Key? key}) : super(key: key);
}

abstract class BasefulWidgetState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();

    /// Load app config on every single page if the appConfig is not init
    // if (kIsWeb) {
    //   Future.delayed(Duration.zero, () async {
    //     var appModel = Provider.of<AppModel>(context, listen: false);
    //     if (appModel.appConfig == null) {
    //       // ignore: avoid_print
    //
    //       /// set the server config at first loading
    //       Services().setAppConfig(serverConfig);
    //       await appModel.loadAppConfig();
    //     }
    //   });
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context) {}

  /// Get size screen
  Size get screenSize => MediaQuery.of(context).size;

  Future<T?> showAlert<T>({
    required Widget child,
  }) {
    return showDialog<T>(
      context: context,
      builder: (c) => child,
    );
  }

  void showSnak(String text, {Color? bgColor, Color? textColor}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      backgroundColor: bgColor,
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnakCustom(SnackBar snackBar) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

//StatelessWidget
abstract class BaseWidget extends StatelessWidget {
  late BuildContext _context;

  BaseWidget({super.key});

  Widget builder(BuildContext context, BoxConstraints constraints);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return LayoutBuilder(builder: builder);
  }

  /// Get size screen
  Size get screenSize => MediaQuery.of(_context).size;

  Future<T?> showAlert<T>({
    required Widget child,
  }) {
    return showDialog<T>(
      context: _context,
      builder: (c) => child,
    );
  }

  void showSnak(String text, {Color? bgColor, Color? textColor}) {
    ScaffoldMessenger.of(_context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      backgroundColor: bgColor,
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );

    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  void showSnakCustom(SnackBar snackBar) {
    ScaffoldMessenger.of(_context).hideCurrentSnackBar();
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }
}
