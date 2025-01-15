import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final String version = await Utils.getAppVersion();
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            CustomText.textContentTitle(
              text: CustomStrings.version,
              context: context,
            ),
            CustomText.textContent(text: _version ?? '0.0.0', context: context),
          ],
        ),
        Utils.dialogDivider(),
        CustomButton(
          iconName: 'none',
          iconTitle: CustomStrings.logout,
          onTap: () => _logout(context),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    final responseData = await context.read<FcmTokenProvider>().deleteFcm();
    if (responseData['code'] == 200) {
      await Future.wait([
        Supabase.instance.client.auth.signOut(),
        SecureStorageUtils.clear(),
      ]);
      if (context.mounted) {
        context.read<AuthStatusProvider>().checkLoginStatus();
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }
}
