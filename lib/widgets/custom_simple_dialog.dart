import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class CustomSimpleDialog extends StatelessWidget {
  final String text;
  final String iconName;
  final String iconTitle;
  final Function onTap;

  const CustomSimpleDialog({
    super.key,
    required this.text,
    required this.iconName,
    required this.iconTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.textDisplay(text: text, context: context),
        CustomButton(iconName: iconName, iconTitle: iconTitle, onTap: onTap),
      ],
    );
  }
}
