import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_shapes.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onIconTap;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              return _buildIconButton(index: index, context: context);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required int index,
    required BuildContext context,
  }) {
    final bool isSelected = currentIndex == index;

    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () => onIconTap(index),
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              isSelected
                  ? CustomColors.colorBase.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.5),
              BlendMode.srcATop,
            ),
            child: SvgPicture.asset(
              'assets/imgs/icon_$index.svg',
              height: 38.0.h,
            ),
          ),
          SizedBox(width: 300.0.w),
          Text(
            CustomStrings.pageNameLists[index],
            style: isSelected
                ? Theme.of(context).textTheme.labelLarge
                : Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
