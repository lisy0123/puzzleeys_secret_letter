import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      margin: const EdgeInsets.only(top: 4.0, left: 70.0),
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
        height: 48.0,
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SvgPicture.asset(
        'assets/imgs/icon_home.svg',
        height: 22.0,
      ),
    );
  }

  Widget _buildIconRow(BuildContext context) {
    const List<double> iconHeight = [22.0, 24.0, 28.0];

    return Container(
      margin: const EdgeInsets.only(top: 14.0, left: 14.0),
      child: Row(
        children: [
          _buildHomeButton(context),
          ...List.generate(iconHeight.length, (index) {
            return Row(
              children: [
                const SizedBox(width: 22.0),
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
