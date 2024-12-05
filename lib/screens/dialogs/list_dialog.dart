import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class ListDialog {
  static Widget screen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(2, (colIndex) {
        return _buildRow(colIndex: colIndex, context: context);
      }),
    );
  }

  static Widget _buildRow({
    required int colIndex,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(2, (rowIndex) {
        final index = colIndex * 2 + rowIndex;
        return _buildIcon(index, context);
      }),
    );
  }

  static Widget _buildIcon(int index, BuildContext context) {
    return Column(
      children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => _showIconDialog(index, context),
          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/imgs/list_$index.svg',
                width: 36.0.h,
              ),
              SizedBox(height: 6.0.h),
              TextSetting.textIconButton(
                text: VarSetting.iconNameLists[index.toString()],
                context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void _showIconDialog(int index, BuildContext context) {
    IconDialog(
      iconName: index.toString(),
      overlapped: true,
    ).buildDialog(context);
  }
}
