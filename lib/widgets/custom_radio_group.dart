import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) labelBuilder;
  final Axis direction;

  const CustomRadioGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final radioTiles = options.map((option) {
      return RadioListTile<T>(
        dense: true,
        title: CustomText.textContentTitle(
          text: labelBuilder(option),
          context: context,
        ),
        value: option,
        groupValue: selectedValue,
        onChanged: onChanged,
        activeColor: CustomColors.colorBase,
      );
    }).toList();

    return direction == Axis.horizontal
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: radioTiles),
          )
        : Column(children: radioTiles);
  }
}
