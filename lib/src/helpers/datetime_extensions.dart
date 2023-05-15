import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDataTime({String? pattern, String? locale}) {
    Intl.defaultLocale = (locale ?? 'pt_BR');
    String ret = "";
    var data = this;
    var dateFormat = DateFormat(pattern ?? 'dd/MM/yyyy HH:mm');
    ret = dateFormat.format(data);
    return ret;
  }

  String formatDate({String? pattern, String? locale}) {
    Intl.defaultLocale = (locale ?? 'pt_BR');
    String ret = "";
    var data = this;
    var dateFormat = DateFormat(pattern ?? 'yyyy-MM-dd');
    ret = dateFormat.format(data);
    return ret;
  }
  //
}
