import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';

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

  static void copyText({
    required String text,
    required String textToCopy,
    required BuildContext context,
  }) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    CustomOverlay.show(text: text, context: context);
  }

  static Widget dialogDivider() {
    return DottedDivider(
        dashWidth: 40.0.w, dashSpace: 20.0.w, thickness: 3.0.w, padding: 0.0.w);
  }
}
