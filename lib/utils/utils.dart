import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Utils {
  static Future<void> waitForSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return;
    }
    await Supabase.instance.client.auth.onAuthStateChange
        .firstWhere((data) => data.session != null);
  }

  static void dismissKeyboard({required FocusNode focusNode}) {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    return version;
  }

  static String convertUTCToKST(String utcTime) {
    DateTime kstTime = DateTime.parse(utcTime).add(Duration(hours: 9));
    String formattedKstTime = DateFormat('yyyy-MM-dd HH:mm').format(kstTime);
    return formattedKstTime;
  }

  static int calculateDays(String? userCreatedAt) {
    if (userCreatedAt != null) {
      DateTime createdDate =
          DateFormat("yyyy-MM-dd HH:mm").parse(userCreatedAt);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(createdDate);
      return difference.inDays;
    } else {
      return 0;
    }
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

  static String getType(PuzzleType puzzleType) {
    return {
          PuzzleType.global: 'global',
          PuzzleType.subject: 'subject',
        }[puzzleType] ??
        'personal';
  }
}
