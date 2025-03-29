import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart' show UpdateStrings;
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class UpdateDialog extends StatelessWidget {
  final String puzzleText;

  const UpdateDialog({super.key, required this.puzzleText});

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: UpdateStrings.content,
      iconName: 'list_8',
      iconTitle: UpdateStrings.update,
      onTap: () {
        Utils.launchURL(puzzleText);
        Navigator.pop(context);
      },
    );
  }
}
