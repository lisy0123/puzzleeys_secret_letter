import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/list/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class ListScreen {
  static Widget listScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(3, (colIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...List.generate(3, (rowIndex) {
                final index = colIndex * 3 + rowIndex;

                return _build(index: index, context: context);
              }),
            ],
          );
        }),
      ],
    );
  }

  static Widget _build({
    required int index,
    required BuildContext context,
  }) {
    return Column(
      children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => IconDialog(
            iconName: index.toString(),
            overlapped: true,
          ).onTap(context),
          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/imgs/list_$index.svg',
                width: 36.0.h,
              ),
              SizedBox(height: 10.0.h),
              TextSetting.textListIconTitle(
                text: VarSetting.listContentLists[index],
                context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
