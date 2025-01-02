import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:provider/provider.dart';

class SetDaysDialog extends StatelessWidget {
  const SetDaysDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: need to fix!
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.textDisplay(
          text: MessageStrings.setDaysMessage,
          context: context,
        ),
        CustomButton(
          iconName: 'btn_puzzle',
          iconTitle: CustomStrings.send,
          onTap: () {
            context.read<WritingProvider>().updateOpacity();
            Navigator.popUntil(context, (route) => route.isFirst);
            CustomOverlay.show(
              text: MessageStrings
                  .overlayMessages[OverlayType.writePuzzleToMe]![1],
              delayed: 2500,
              puzzleVis: true,
              puzzleNum: MessageStrings
                  .overlayMessages[OverlayType.writePuzzleToMe]![0],
              context: context,
            );
          },
        ),
      ],
    );
  }
}
