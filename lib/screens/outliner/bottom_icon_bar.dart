import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_ui.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class ButtonIconBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onIconTap;

  const ButtonIconBar({
    super.key,
    required this.currentIndex,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomUi.buildWhiteBox(context: context),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(left: 40.0.w, right: 40.0.w, top: 16.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(3, (generator) {
                  return Row(
                    children: [
                      _buildIconButton(
                        index: generator,
                        context: context,
                      ),
                    ],
                  );
                }),
              ],
            ),
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

    return GestureDetector(
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => onIconTap(index),
        icon: Column(
          children: [
            SvgPicture.asset(
              'assets/imgs/icon_$index.svg',
              height: 40.0.h,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? ColorSetting.colorBase.withOpacity(0.2)
                    : Colors.white.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            ),
            SizedBox(width: 500.0.w),
            TextSetting.textMainIconTitle(
              index: isSelected,
              text: VarSetting.mainIconNameLists[index],
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
