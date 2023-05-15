import 'package:flutter/material.dart';

class Nav {
  static NavState of(BuildContext context) {
    return NavState(context);
  }

  static Future<T?> goNamed<T extends Object?>(BuildContext context, String name) {
    final navigator = Nav.of(context);
    return navigator.goNamed<T>(name);
  }

  static Future<T?> go<T extends Object?>(BuildContext context, Widget page) {
    final navigator = Nav.of(context);
    return navigator.go<T>(page);
  }

  static Future<dynamic> toNamed(BuildContext context, String name) {
    final navigator = Nav.of(context);
    return navigator.toNamed(name);
  }

  static Future<dynamic> to(BuildContext context, Widget page) {
    final navigator = Nav.of(context);
    return navigator.to(page);
  }

  static void back<T extends Object?>(BuildContext context, [T? result]) {
    final navigator = Nav.of(context);
    return navigator.back<T>(result);
  }
}

class NavState {
  late NavigatorState _navigatorState;

  NavState(BuildContext context) {
    _navigatorState = Navigator.of(context);
  }

  Future<T?> goNamed<T extends Object?>(String name) {
    return _navigatorState.pushNamed<T>(name);
  }

  Future<T?> go<T extends Object?>(Widget page) {
    return _navigatorState.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<dynamic> toNamed(String name) {
    return _navigatorState.pushNamedAndRemoveUntil(
      name,
      (v) => false,
    );
  }

  Future<dynamic> to(Widget page) {
    return _navigatorState.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (v) => false,
    );
  }

  void back<T extends Object?>([T? result]) {
    return _navigatorState.pop(result);
  }

  bool canBack() {
    return _navigatorState.canPop();
  }
}
