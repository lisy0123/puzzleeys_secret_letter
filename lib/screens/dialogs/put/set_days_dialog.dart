import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/complete_puzzle.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_radio_group.dart';

class SetDaysDialog extends StatefulWidget {
  final Map<String, dynamic> puzzleData;

  const SetDaysDialog({super.key, required this.puzzleData});

  @override
  State<SetDaysDialog> createState() => _SetDaysDialogState();
}

class _SetDaysDialogState extends State<SetDaysDialog> {
  int? _selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 160.0.w, vertical: 120.0.w),
          child: CustomRadioGroup(
            options: [1, 3, 7],
            selectedValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
            labelBuilder: (option) => "$option${CustomStrings.day}",
          ),
        ),
        CustomButton(
          iconName: 'btn_puzzle',
          iconTitle: CustomStrings.send,
          onTap: () => CompletePuzzle(
            overlayType: OverlayType.writePuzzleToMe,
            puzzleType: PuzzleType.me,
            puzzleData: widget.puzzleData,
            sendDays: _selectedOption,
            context: context,
          ).post(),
        ),
      ],
    );
  }
}
