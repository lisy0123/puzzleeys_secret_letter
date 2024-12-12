import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Column(
        children: List.generate(2, (colIndex) {
          return _buildRow(colIndex: colIndex, context: context);
        }),
      ),
    );
  }

  Widget _buildRow({
    required int colIndex,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(4, (rowIndex) {
        final index = colIndex * 2 + rowIndex;
        return _buildColorPicker(index, context);
      }),
    );
  }

  // TODO
  Widget _buildColorPicker(int index, BuildContext context) {
    return Container(
      color: ColorSetting.colorPink,
      width: 240.0.w,
      height: 240.0.w,
    );
  }
}
