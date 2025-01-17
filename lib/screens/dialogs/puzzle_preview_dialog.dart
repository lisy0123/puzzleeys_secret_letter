import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzlePreviewDialog extends StatelessWidget {
  final int index;
  final Map<String, dynamic> puzzleData;
  final PuzzleType puzzleType;

  const PuzzlePreviewDialog({
    super.key,
    required this.index,
    required this.puzzleData,
    required this.puzzleType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TiltedPuzzle(puzzleColor: puzzleData['color']),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            child: SizedBox(
              height: 340.0.w,
              width: double.infinity,
              child: Center(
                child: CustomText.textContent(
                  text: puzzleData['title'].replaceAll(r'\n', '\n'),
                  context: context,
                ),
              ),
            ),
          ),
          CustomButton(
            iconName: 'btn_puzzle',
            iconTitle: CustomStrings.preview,
            onTap: () {
              Navigator.pop(context);
              PuzzleScreenHandler.navigateScreen(
                barrierColor: puzzleData['color'].withValues(alpha: 0.8),
                child: PuzzleDetailScreen(
                  index: index,
                  puzzleData: puzzleData,
                  puzzleType: puzzleType,
                ),
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
