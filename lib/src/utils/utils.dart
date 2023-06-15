import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Future<QuerySnapshot<T>> getTimeout<T>(Query<T> query, {int seconds = 10}) => query.get().timeout(Duration(seconds: seconds));

T getMap<T>({
  required String key,
  required Map<String, dynamic> map,
  required T retur,
  bool parseInt = false,
  bool parseDouble = false,
  T Function(dynamic)? parseFromJson,
}) {
  if (parseFromJson != null) {
    return map.containsKey(key) && map[key] != null ? parseFromJson(map[key]) : retur;
  }
  if (parseInt) {
    return (map.containsKey(key) && map[key] != null ? int.parse(map[key].toString()) : retur) as T;
  }
  if (parseDouble) {
    return (map.containsKey(key) && map[key] != null ? double.parse(map[key].toString()) : retur) as T;
  }
  return map.containsKey(key) && map[key] != null ? map[key] : retur;
}

class Utils {
  static Future<void> copyToClipBoard({
    required String copy,
  }) {
    return Clipboard.setData(
      ClipboardData(text: copy),
    );
  }

  static Widget responsiveRowCol({
    required bool condicao,
    required List<Widget> children,
    bool center = false,
    MainAxisAlignment rowMainAxisAligment = MainAxisAlignment.start,
    CrossAxisAlignment colCrossAxisAligment = CrossAxisAlignment.start,
  }) {
    return condicao
        ? Row(
            mainAxisAlignment: center ? MainAxisAlignment.center : rowMainAxisAligment,
            children: children,
          )
        : Column(
            crossAxisAlignment: center ? CrossAxisAlignment.center : colCrossAxisAligment,
            children: children,
          );
  }

  static double getWidthDialog(BuildContext context, {double? multpli}) {
    if (multpli != null) {
      return MediaQuery.of(context).size.width * multpli;
    }
    return MediaQuery.of(context).size.width;
  }

  static int getRowLines({
    required int length,
    required bool empty,
    int qt = 10,
  }) {
    return length > qt
        ? qt
        : empty
            ? 1
            : length;
  }

  static double getHeightDialog(BuildContext context, {double? multpli}) {
    if (multpli != null) {
      return MediaQuery.of(context).size.height * multpli;
    }
    return MediaQuery.of(context).size.height;
  }

  static String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "E-mail já utilizado. Vá para a página de login.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Combinação de e-mail ou senha errada.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Nenhum usuário encontrado com este e-mail.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Usuário desativado.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Muitos pedidos para entrar nesta conta.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Erro do servidor, tente novamente mais tarde.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Endereço de email inválido.";
      default:
        return "NOT";
    }
  }

  static void mostrarMsgTop(BuildContext context, String value, bool erro) {
    showTopSnackBar(
      Overlay.of(context)!,
      CustomSnackBar.info(
        backgroundColor: erro ? Colors.red : Colors.green,
        message: value,
        icon: const Text(""),
      ),
    );
  }

  static void snakBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  static Widget umOuOutro({
    required bool condicao,
    required Widget sim,
    required Widget nao,
  }) {
    return condicao ? sim : nao;
  }

  static void toast({
    required String message,
    required BuildContext context,
    IconData? icon,
    bool isError = false,
    bool isAlert = false,
    int seconds = 2,
  }) {
    final fToast = FToast();
    fToast.removeQueuedCustomToasts();

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isError
            ? const Color(0xffF14E3C)
            : isAlert
                ? const Color(0xff84919E)
                : const Color(0xff24af42),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );

    fToast.init(context);
    fToast.showToast(
        child: toast,
        gravity: kIsWeb ? ToastGravity.TOP_RIGHT : ToastGravity.TOP,
        toastDuration: Duration(seconds: seconds),
        positionedToastBuilder: (context, child) {
          if (kIsWeb) {
            return Positioned(
              top: 16.0,
              right: 16.0,
              child: child,
            );
          } else {
            return child;
          }
        });
  }

  static void hideKeyboard(BuildContext context) {
    double key = WidgetsBinding.instance.window.viewInsets.bottom;
    if (key > 0.0) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  static Future<T?> dialogFuture<T>({
    required BuildContext context,
    Widget? message,
    VoidCallback? onSim,
    VoidCallback? onNao,
    Color? textColorSim,
    Color? textColorNao,
    String? textSim,
    String? textNao,
    Color? buttonColorSim,
    Color? buttonColorNao,
    Color? backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    Widget? title,
    double? radius,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleTextStyle,
    ShapeBorder? shape,
    bool scrollable = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: scrollable,
          contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          title: title,
          titlePadding: titlePadding,
          titleTextStyle: titleTextStyle,
          backgroundColor: backgroundColor,
          shape: radius != null ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)) : shape,
          content: message ?? const Text("Você deseja realmente excluir esse item?"),
          actions: <Widget>[
            if (onNao != null)
              MaterialButton(
                color: buttonColorNao ?? Colors.redAccent,
                onPressed: onNao,
                child: Text(
                  textNao ?? "Não",
                  style: TextStyle(
                    color: textColorNao ?? Colors.white,
                  ),
                ),
              ),
            if (onSim != null)
              MaterialButton(
                color: buttonColorSim ?? Theme.of(context).primaryColor,
                onPressed: onSim,
                child: Text(
                  textSim ?? 'Sim',
                  style: TextStyle(
                    color: textColorSim ?? Colors.white,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  static Future<T?> drawerFuture<T>({
    required BuildContext context,
    Widget? child,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenW = MediaQuery.of(context).size.width;
        final w = screenW / 2;
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          alignment: Alignment.centerRight,
          content: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                topRight: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
              ),
            ),
            width: w <= 600 ? 600 : w,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: child,
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          backgroundColor: const Color(0xFFF2F2F7),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              topRight: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
          ),
        );
      },
    );
  }

  static delay(int i, {int? milliseconds}) => Future.delayed(milliseconds != null ? Duration(milliseconds: milliseconds) : Duration(seconds: i));

  /// Componente de delay em milliseconds.
  ///
  /// 1000 = 1 segundo e assim por diante.
  static delay2({int milliseconds = 1000}) => Future.delayed(Duration(milliseconds: milliseconds));

  static valorPorcentagem({required dynamic total, required dynamic totalItem}) {
    return (totalItem * 100 / total).toStringAsFixed(2);
  }

  static double valorPorcentagem0a1({required dynamic total, required dynamic totalItem}) {
    return double.parse(((totalItem * 100 / total) / 100).toStringAsFixed(2));
  }
}
