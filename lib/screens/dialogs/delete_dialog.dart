import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.textDisplay(
          text: MessageStrings.deleteMessage,
          context: context,
        ),
        CustomButton(
          iconName: 'btn_trash',
          iconTitle: CustomStrings.deleteLong,
          onTap: () {
            Navigator.pop(context);
            // TODO: need to add backup api
          },
        ),
      ],
    );
  }
}
