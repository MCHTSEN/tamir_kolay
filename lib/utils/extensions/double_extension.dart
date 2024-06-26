import 'package:intl/intl.dart';

extension CurrencyFormatterDouble on double {
  String toCurrency() {
    final currencyFormat =
        NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 2);
    return currencyFormat.format(this);
  }
}
