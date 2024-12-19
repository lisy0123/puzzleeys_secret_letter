import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static void dismissKeyboard({required FocusNode focusNode}) {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  static String convertUTCToKST(String utcTime) {
    DateTime kstTime = DateTime.parse(utcTime).add(Duration(hours: 9));
    String formattedKstTime = DateFormat('yyyy-MM-dd HH:mm').format(kstTime);
    return formattedKstTime;
  }
}
