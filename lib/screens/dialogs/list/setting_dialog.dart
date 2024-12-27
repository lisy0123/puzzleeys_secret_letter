import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            CustomText.textContentTitle(text: '버전', context: context),
            CustomText.textContent(
              text: CustomVars.version,
              context: context,
            ),
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
    final url =
        Uri.parse('${dotenv.env['PROJECT_URL']}/functions/v1/api/logout');
    await http.post(url);
    await _secureStorage.delete(key: 'access');

    if (context.mounted) {
      context.read<AuthStatusProvider>().checkLoginStatus();
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
