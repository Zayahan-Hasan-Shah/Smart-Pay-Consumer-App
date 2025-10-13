import 'package:flutter/services.dart';

class PakistanPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    // Case 1: Starts with 92 → +92 XXX XXXXXXX
    if (digits.startsWith('92')) {
      formatted = '+92';
      if (digits.length > 2) {
        formatted += ' ';
        if (digits.length > 4) {
          formatted += digits.substring(
            2,
            digits.length >= 5 ? 5 : digits.length,
          );
          if (digits.length > 5) {
            formatted += ' ' + digits.substring(5);
          }
        } else {
          formatted += digits.substring(2);
        }
      }
    }
    // Case 2: Starts with 03 → 03XX XXX XXXX
    else if (digits.startsWith('03')) {
      formatted = digits.substring(0, digits.length >= 2 ? 2 : digits.length);

      if (digits.length > 2) {
        formatted += digits.substring(
          2,
          digits.length >= 5 ? 5 : digits.length,
        );
      }

      if (digits.length > 5) {
        formatted +=
            ' ' + digits.substring(5, digits.length >= 8 ? 8 : digits.length);
      }

      if (digits.length > 8) {
        formatted += ' ' + digits.substring(8);
      }
    }
    // Case 3: Default (other numbers)
    else {
      formatted = digits;
    }

    // Maintain cursor position safely
    int offset = formatted.length;
    if (offset > newValue.selection.baseOffset) {
      offset = newValue.selection.baseOffset;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
