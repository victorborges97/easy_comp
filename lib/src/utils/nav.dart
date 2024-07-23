import 'package:flutter/material.dart';

class Nav {
  static NavState of(BuildContext context) {
    return NavState(context);
  }

  /// author: João Victor
  ///
  /// goNamed => pushNamed
  static Future<T?> goNamed<T extends Object?>(BuildContext context, String name, {Object? arguments}) {
    final navigator = Nav.of(context);
    return navigator.goNamed<T>(name, arguments: arguments);
  }

  /// author: João Victor
  ///
  /// go => push
  static Future<T?> go<T extends Object?>(BuildContext context, Widget page) {
    final navigator = Nav.of(context);
    return navigator.go<T>(page);
  }

  /// author: João Victor
  ///
  /// toNamed => pushNamedAndRemoveUntil
  static Future<dynamic> toNamed(
    BuildContext context,
    String name, {
    bool Function(Route<dynamic>)? predicate,
    Object? arguments,
  }) {
    final navigator = Nav.of(context);
    return navigator.toNamed(name, predicate: predicate, arguments: arguments);
  }

  /// author: João Victor
  ///
  /// to => pushAndRemoveUntil
  static Future<dynamic> to(BuildContext context, Widget page, {bool Function(Route<dynamic>)? predicate}) {
    final navigator = Nav.of(context);
    return navigator.to(page, predicate: predicate);
  }

  /// author: João Victor
  ///
  /// back => pop
  static void back<T extends Object?>(BuildContext context, [T? result]) {
    final navigator = Nav.of(context);
    return navigator.back<T>(result);
  }

  /// author: João Victor
  ///
  /// canBack => canPop
  static bool canBack(BuildContext context) {
    final navigator = Nav.of(context);
    return navigator.canBack();
  }
}

class NavState {
  late NavigatorState _navigatorState;

  NavState(BuildContext context) {
    _navigatorState = Navigator.of(context);
  }

  Future<T?> goNamed<T extends Object?>(String name, {Object? arguments}) {
    return _navigatorState.pushNamed<T>(name, arguments: arguments);
  }

  Future<T?> go<T extends Object?>(Widget page) {
    return _navigatorState.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<dynamic> toNamed(String name, {bool Function(Route<dynamic>)? predicate, Object? arguments}) {
    return _navigatorState.pushNamedAndRemoveUntil(
      name,
      predicate ?? (v) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> to(Widget page, {bool Function(Route<dynamic>)? predicate}) {
    return _navigatorState.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      predicate ?? (v) => false,
    );
  }

  void back<T extends Object?>([T? result]) {
    return _navigatorState.pop(result);
  }

  bool canBack() {
    return _navigatorState.canPop();
  }
}
