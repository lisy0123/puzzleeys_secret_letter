import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/writing/writing_provider.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';

class CancelDialog extends StatelessWidget {
  const CancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextSetting.textDisplay(
          text: '돌아가면\n편지가 지워져요!',
          context: context,
        ),
        CustomButton(
          iconName: 'btn_back',
          iconTitle: '돌아가기',
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            context.read<WritingProvider>().toggleVisibility();
          },
        ),
      ],
    );
  }
}
