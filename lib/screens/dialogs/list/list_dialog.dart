import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class ListDialog extends StatelessWidget {
  const ListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(3, (colIndex) {
        return _buildRow(colIndex: colIndex, context: context);
      }),
    );
  }

  Widget _buildRow({
    required int colIndex,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(3, (rowIndex) {
        final index = colIndex * 3 + rowIndex;
        return _buildIcon(index, context);
      }),
    );
  }

  Widget _buildIcon(int index, BuildContext context) {
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
                colorFilter: ColorFilter.mode(
                  index == 4
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.transparent,
                  BlendMode.srcATop,
                ),
              ),
              SizedBox(height: 6.0.h, width: 300.0.w),
              CustomText.textDisplay(
                text: CustomStrings.dialogNameLists[index.toString()]!,
                disable: index == 4 ? true : false,
                context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showIconDialog(int index, BuildContext context) {
    if (index != 4) {
      BuildDialog.show(
        iconName: index.toString(),
        overlapped: true,
        context: context,
      );
    }
  }
}
