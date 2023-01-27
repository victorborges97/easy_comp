import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum ValuePosition { center, right }

class CustomLoading {
  late BuildContext _context;

  static IDialog? _current;

  CustomLoading({required context}) {
    _context = context;
  }

  void update({required int value, String? msg}) {
    if (_current != null) {
      _current?.update(
        value: value,
        msg: msg,
      );
    }
  }

  void close() {
    if (isOpen()) {
      _current?.dismiss();
      _current = null;
    }
  }

  bool isOpen() {
    return _current != null;
  }

  show({
    int max = 0,
    String? msg,
    ValuePosition valuePosition = ValuePosition.right,
    Color backgroundColor = Colors.black45,
    Color barrierColor = Colors.black26,
    Color progressValueColor = Colors.white,
    Color progressBgColor = Colors.blueGrey,
    Color valueColor = Colors.white,
    Color msgColor = Colors.white,
    FontWeight msqFontWeight = FontWeight.bold,
    FontWeight valueFontWeight = FontWeight.normal,
    double valueFontSize = 15.0,
    double msgFontSize = 17.0,
    int msgMaxLines = 1,
    double elevation = 2.0,
    double borderRadius = 8.0,
    bool barrierDismissible = false,
  }) {
    _current = LoadDialog(
      msg: msg,
      borderRadius: borderRadius,
      msgMaxLines: msgMaxLines,
      msgFontSize: msgFontSize,
      valueFontSize: valueFontSize,
      valuePosition: valuePosition,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      progressValueColor: progressValueColor,
      progressBgColor: progressBgColor,
      valueColor: valueColor,
      msgColor: msgColor,
      msqFontWeight: msqFontWeight,
      valueFontWeight: valueFontWeight,
    );

    return showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      context: _context,
      builder: (context) => WillPopScope(
        child: _current ??
            LoadDialog(
              msg: msg,
              borderRadius: borderRadius,
              msgMaxLines: msgMaxLines,
              msgFontSize: msgFontSize,
              valueFontSize: valueFontSize,
              valuePosition: valuePosition,
              backgroundColor: backgroundColor,
              barrierColor: barrierColor,
              progressValueColor: progressValueColor,
              progressBgColor: progressBgColor,
              valueColor: valueColor,
              msgColor: msgColor,
              msqFontWeight: msqFontWeight,
              valueFontWeight: valueFontWeight,
            ),
        onWillPop: () => Future.value(
          barrierDismissible,
        ),
      ),
    );
  }

// Center(
//   child: Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.all(
//         Radius.circular(borderRadius),
//       ),
//       color: backgroundColor,
//     ),
//     width: msg != null ? 180 : 90,
//     height: 90,
//     child:  Center(
//       child: ValueListenableBuilder(
//         valueListenable: _progress,
//         builder: (BuildContext context, dynamic value, Widget? child) {
//           if (value == max) close();
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 child: _normalProgress(
//                   bgColor: progressBgColor,
//                   valueColor: progressValueColor,
//                 ),
//               ),
//               Visibility(
//                 visible: msg != null,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 8.0,
//                   ),
//                   child: Text(
//                     _msg.value,
//                     maxLines: msgMaxLines,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: msgFontSize,
//                       color: msgColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     ),
//   ),
// )
}

mixin IDialogService {
  void dismiss();

  void update({required int value, String? msg});
}

abstract class IDialog extends StatelessWidget with IDialogService {
  const IDialog({Key? key}) : super(key: key);
}

// ignore: must_be_immutable
class LoadDialog extends IDialog {
  final String? msg;
  final ValuePosition valuePosition;
  final Color backgroundColor;
  final Color barrierColor;
  final Color progressValueColor;
  final Color progressBgColor;
  final Color valueColor;
  final Color msgColor;
  final FontWeight msqFontWeight;
  final FontWeight valueFontWeight;
  final double valueFontSize;
  final double msgFontSize;
  final double elevation;
  final double borderRadius;
  final int msgMaxLines;

  LoadDialog({
    Key? key,
    this.msg,
    this.valuePosition = ValuePosition.right,
    this.backgroundColor = Colors.black45,
    this.barrierColor = Colors.black26,
    this.progressValueColor = Colors.white,
    this.progressBgColor = Colors.blueGrey,
    this.valueColor = Colors.white,
    this.msgColor = Colors.white,
    this.msqFontWeight = FontWeight.bold,
    this.valueFontWeight = FontWeight.normal,
    this.valueFontSize = 15.0,
    this.msgFontSize = 17.0,
    this.elevation = 2.0,
    this.borderRadius = 8.0,
    this.msgMaxLines = 1,
  }) : super(key: key);

  final ValueNotifier _progress = ValueNotifier(1);
  final ValueNotifier _msg = ValueNotifier('');

  void atualizar({required int value, String? msg}) {
    _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  _normalProgress({Color? valueColor, Color? bgColor}) {
    return SpinKitFadingCircle(
      color: valueColor,
      size: 50,
    );
  }

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    if (msg != null) _msg.value = msg;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          color: backgroundColor,
        ),
        width: msg != null ? 180 : 90,
        height: 90,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: _progress,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: _normalProgress(
                      bgColor: progressBgColor,
                      valueColor: progressValueColor,
                    ),
                  ),
                  Visibility(
                    visible: msg != null,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: Text(
                        _msg.value!,
                        maxLines: msgMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: msgFontSize,
                          color: msgColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dismiss() {
    Navigator.pop(_context!);
  }

  @override
  void update({required int value, String? msg}) {
    atualizar(
      value: value,
      msg: msg,
    );
  }
}
