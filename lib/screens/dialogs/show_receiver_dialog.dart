import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class ShowReceiverDialog extends StatelessWidget {
  const ShowReceiverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.textDisplay(text: CustomStrings.sendToWho, context: context),
        CustomButton(
          iconName: 'none',
          iconTitle: CustomStrings.sendToOther,
          width: 500.0,
          onTap: () {
            Navigator.pop(context);
            PuzzleScreenHandler.navigateScreen(
              barrierColor: Colors.white70,
              child: PuzzleWritingScreen(
                puzzleType: PuzzleType.personal,
                reply: false,
              ),
              context: context,
            );
          },
        ),
        CustomButton(
          iconName: 'none',
          iconTitle: CustomStrings.sendToMe,
          onTap: () {
            Navigator.pop(context);
            PuzzleScreenHandler.navigateScreen(
              barrierColor: Colors.white70,
              child: PuzzleWritingScreen(
                puzzleType: PuzzleType.me,
                reply: false,
              ),
              context: context,
            );
          },
        ),
      ],
    );
  }
}
