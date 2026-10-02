import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    

    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final number = int.parse(cleanText);
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    String newText = formatter.format(number).trim();

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
