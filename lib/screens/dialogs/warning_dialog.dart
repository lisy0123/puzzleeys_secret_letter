import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class WarningDialog extends StatelessWidget {
  final int dialogType;

  const WarningDialog({
    super.key,
    required this.dialogType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.textDisplay(
          text: CustomStrings.warningMessageLists[dialogType],
          context: context,
        ),
        CustomButton(
          iconName: 'btn_back',
          iconTitle: CustomStrings.back,
          onTap: () {
            Navigator.pop(context);
            if (dialogType == 0) {
              Navigator.pop(context);
              context.read<WritingProvider>().updateOpacity();
            }
          },
        ),
      ],
    );
  }
}
