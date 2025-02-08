import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class ParentWidget extends StatelessWidget {
  final String? parentPostColor;
  final String parentPostType;

  const ParentWidget({
    super.key,
    this.parentPostColor,
    required this.parentPostType,
  });

  @override
  Widget build(BuildContext context) {
    final int iconIndex = GetPuzzleType.stringToIndex(parentPostType);
    final bool isExist = parentPostColor != null;
    final double iconHeight = isExist ? 160.0 : 120.0;

    return Padding(
      padding: EdgeInsets.all(20.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isExist) _buildExist(),
          if (iconIndex != 2) SizedBox(width: 20.0.w),
          SvgPicture.asset(
            'assets/imgs/icon_${iconIndex.toString()}.svg',
            height: (iconIndex == 2) ? iconHeight.w : (iconHeight - 10).w,
            colorFilter: isExist
                ? null
                : ColorFilter.mode(
                    CustomColors.colorBase.withValues(alpha: 0.2),
                    BlendMode.srcATop,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExist() {
    return Row(
      children: [
        SizedBox(width: 80.0.w),
        Transform.rotate(
          angle: -pi / 4,
          child: CustomPaint(
            size: Size(180.0.w, 180.0.w),
            painter: TiltedPuzzlePiece(
              puzzleColor: ColorUtils.colorMatch(stringColor: parentPostColor),
              strokeWidth: 1.2,
            ),
          ),
        )
      ],
    );
  }
}
