import 'package:intl/intl.dart';

extension CurrencyPTBRExtension on double {
  String get currencyPTBR {
    final currencyFormat = NumberFormat.currency(
      locale: "pt_BR",
      symbol: r"R$",
    );

    return currencyFormat.format(this);
  }

  String get currencyPTBROutSymbol {
    final currencyFormat = NumberFormat.currency(
      locale: "pt_BR",
      symbol: "",
    );

    return currencyFormat.format(this);
  }
}

extension FutureExtension on Future {
  Future delay(int s) => Future.delayed(Duration(seconds: s));
}
