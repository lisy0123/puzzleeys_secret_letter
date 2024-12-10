import 'package:flutter/services.dart';

class LineLimitingTextInputFormatter extends TextInputFormatter {
  final int maxLines;

  LineLimitingTextInputFormatter(this.maxLines);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final lineCount = '\n'.allMatches(newValue.text).length + 1;
    if (lineCount > maxLines) {
      return oldValue;
    }
    return newValue;
  }
}
