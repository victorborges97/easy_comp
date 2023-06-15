import 'package:easy_comp/easy_comp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum EasyCompLoadingPosition { center, right }

enum EasyCompLoadingTypeTheme { one, two }

class EasyCompLoading {
  late BuildContext _context;

  static IEasyCompLoading? _current;

  EasyCompLoading({required context}) {
    _context = context;
  }

  void update({int? value, String? msg}) {
    if (_current != null) {
      _current?.update(
        value: value,
        msg: msg,
      );
    }
  }

  void updateAndClose({int? value, String? msg, int timeOut = 200}) async {
    if (_current != null) {
      _current?.update(
        value: value,
        msg: msg,
      );
    }
    await Utils.delay2(milliseconds: timeOut);
    close();
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
    int? max,
    String? msg,
    EasyCompLoadingTypeTheme typeTheme = EasyCompLoadingTypeTheme.one,
    EasyCompLoadingPosition valuePosition = EasyCompLoadingPosition.right,
    Color? backgroundColor,
    Color? msgColor,
    Color barrierColor = Colors.black26,
    Color progressValueColor = Colors.white,
    Color progressBgColor = Colors.blueGrey,
    Color valueColor = Colors.white,
    FontWeight msqFontWeight = FontWeight.bold,
    FontWeight valueFontWeight = FontWeight.normal,
    double valueFontSize = 15.0,
    double msgFontSize = 17.0,
    int msgMaxLines = 1,
    double elevation = 2.0,
    double borderRadius = 8.0,
    bool barrierDismissible = false,
    Color? bgColorLinear,
    Color? colorLinear,
  }) {
    if (typeTheme == EasyCompLoadingTypeTheme.one && backgroundColor == null) {
      backgroundColor = Colors.black45;
      msgColor = Colors.white;
    } else if (typeTheme == EasyCompLoadingTypeTheme.two) {
      backgroundColor = Colors.white;
      msgColor = Colors.grey.shade900;
    }

    _current ??= LoadEasyCompLoading(
      context: _context,
      msg: msg,
      max: max,
      borderRadius: borderRadius,
      msgMaxLines: msgMaxLines,
      msgFontSize: msgFontSize,
      valueFontSize: valueFontSize,
      valuePosition: valuePosition,
      backgroundColor: backgroundColor!,
      barrierColor: barrierColor,
      progressValueColor: progressValueColor,
      progressBgColor: progressBgColor,
      valueColor: valueColor,
      msgColor: msgColor!,
      msqFontWeight: msqFontWeight,
      valueFontWeight: valueFontWeight,
      bgColorLinear: bgColorLinear,
      colorLinear: colorLinear,
    );

    return showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      context: _context,
      builder: (context) => WillPopScope(
        child: _current!,
        onWillPop: () => Future.value(
          barrierDismissible,
        ),
      ),
    );
  }
}

mixin IEasyCompLoadingService {
  void dismiss();

  void update({int? value, String? msg});
}

abstract class IEasyCompLoading extends StatelessWidget with IEasyCompLoadingService {
  const IEasyCompLoading({Key? key}) : super(key: key);
}

// ignore: must_be_immutable
class LoadEasyCompLoading extends IEasyCompLoading {
  final String? msg;
  final EasyCompLoadingPosition valuePosition;
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
  final int? max;
  final Color? bgColorLinear;
  final Color? colorLinear;

  LoadEasyCompLoading({
    super.key,
    required BuildContext context,
    this.msg,
    this.max,
    this.valuePosition = EasyCompLoadingPosition.right,
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
    this.bgColorLinear,
    this.colorLinear,
  }) {
    _context = context;
  }

  final ValueNotifier _progress = ValueNotifier(1);
  final ValueNotifier _msg = ValueNotifier('');

  void atualizar({int? value, String? msg}) {
    if (value != null) _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  _normalProgress({Color? valueColor, Color? bgColor}) {
    return SpinKitFadingCircle(
      color: valueColor,
      size: 50,
    );
  }

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    if (msg != null) _msg.value = msg;
    return Center(
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
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
                if (msg != null && max != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _msg.value!,
                                maxLines: msgMaxLines,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: msgFontSize,
                                  color: msgColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 8.0,
                        ),
                        child: LinearProgressIndicator(
                          value: Utils.valorPorcentagem0a1(total: max, totalItem: value),
                          backgroundColor: bgColorLinear == null && backgroundColor == Colors.white ? Colors.grey.shade300 : bgColorLinear,
                          color: colorLinear,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: msgColor,
                              ),
                            ),
                            Text(
                              max.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: msgColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                if (msg != null) {
                  return Column(
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
                }
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
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dismiss() {
    Navigator.pop(_context);
  }

  @override
  void update({int? value, String? msg}) {
    atualizar(
      value: value,
      msg: msg,
    );
  }
}
