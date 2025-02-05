import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/providers/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(2, (colIndex) {
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
      children: List.generate(4, (rowIndex) {
        final index = colIndex * 4 + rowIndex;
        return _buildColorPicker(index, context);
      }),
    );
  }

  Widget _buildColorPicker(int index, BuildContext context) {
    final Color color = CustomVars.myColorPickers[index];
    final ColorPickerProvider colorProvider =
        context.read<ColorPickerProvider>();

    return Container(
      width: 260.0.w,
      height: 260.0.w,
      margin: EdgeInsets.only(left: 20.0.w, top: 40.0.w),
      child: GestureDetector(
        onTap: () {
          colorProvider.updateColor(color: color);
          colorProvider.updateOpacity();
        },
        child: Container(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          decoration: BoxDecorations.colorList(color: color),
        ),
      ),
    );
  }
}
