import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormatter =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  static String format(double value) {
    return _currencyFormatter.format(value);
  }
}
