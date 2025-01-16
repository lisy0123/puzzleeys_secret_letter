import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class WarningDialog extends StatelessWidget {
  final Enum dialogType;

  const WarningDialog({super.key, required this.dialogType});

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: MessageStrings.warningMessages[dialogType]!,
      iconName: 'btn_back',
      iconTitle: CustomStrings.back,
      onTap: () {
        Navigator.pop(context);
        if (dialogType == WarningType.cancel) {
          Navigator.pop(context);
          context.read<WritingProvider>().updateOpacity();
        }
      },
    );
  }
}
