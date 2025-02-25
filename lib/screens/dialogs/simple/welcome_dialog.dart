import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart' show Utils;
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: MessageStrings.welcomeMessage,
      iconName: 'btn_puzzle',
      iconTitle: CustomStrings.howToUse,
      onTap: () {
        Utils.launchURL(CustomStrings.howToUseUrl);
        Navigator.pop(context);
      },
    );
  }
}
