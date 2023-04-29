import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIDR(dynamic number) {
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2);
    return currencyFormatter.format(number);
  }
}
