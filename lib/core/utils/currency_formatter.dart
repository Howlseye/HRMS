import 'package:intl/intl.dart';

class AppCurrencyFormatter {
  static double parseToDouble(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is num) return amount.toDouble();
    if (amount is String) {
      if (amount.contains('Rp') || amount.contains(',')) {
        final cleanStr = amount.replaceAll(RegExp(r'[^0-9]'), '');
        return double.tryParse(cleanStr) ?? 0.0;
      } else {
        final cleanStr = amount.replaceAll(RegExp(r'[^0-9.]'), '');
        return double.tryParse(cleanStr) ?? 0.0;
      }
    }
    return 0.0;
  }

  static String format(dynamic amount) {
    if (amount == null) return '-';
    
    double value = parseToDouble(amount);

    if (value == 0 && amount.toString().isEmpty) return '-';

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }
}
