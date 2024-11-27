import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';

class PuzzleIcons extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onIconTap;

  const PuzzleIcons({
    super.key,
    required this.currentIndex,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 24.0.w, left: 400.0.w),
      child: Stack(
        children: [
          _buildBackGround(),
          _buildIconRow(context),
        ],
      ),
    );
  }

  Widget _buildBackGround() {
    return Container(
      decoration: BoxDecorationSetting.boxDecorationIcon(),
      child: SvgPicture.asset(
        'assets/imgs/navigation_bar.svg',
        height: 66.0.h,
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SvgPicture.asset(
        'assets/imgs/icon_home.svg',
        height: 30.0.h,
      ),
    );
  }

  Widget _buildIconRow(BuildContext context) {
    final List<double> iconHeight = [30.0.h, 32.0.h, 34.0.h];

    return Container(
      margin: EdgeInsets.only(top: 22.0.h, left: 20.0.h),
      child: Row(
        children: [
          _buildHomeButton(context),
          ...List.generate(iconHeight.length, (index) {
            return Row(
              children: [
                SizedBox(width: 30.0.h),
                _buildIconButton(
                  index: index,
                  iconHeight: iconHeight[index],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required int index,
    required double iconHeight,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onIconTap(index),
      child: SvgPicture.asset(
        'assets/imgs/icon_$index.svg',
        height: iconHeight,
        colorFilter: ColorFilter.mode(
          isSelected
              ? ColorSetting.colorBase.withOpacity(0.3)
              : Colors.transparent,
          BlendMode.srcATop,
        ),
      ),
    );
  }
}
