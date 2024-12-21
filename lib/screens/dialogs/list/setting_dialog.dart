import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

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
          onTap: () async {
            await Supabase.instance.client.auth.signOut();
            Future.delayed(Duration.zero, () {
              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            });
          },
        ),
      ],
    );
  }
}
