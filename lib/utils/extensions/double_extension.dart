import 'package:intl/intl.dart';

extension CurrencyFormatterDouble on double {
  String toCurrency() {
    final formatX =
        NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 2);
    return formatX.format(this);
  }
}
