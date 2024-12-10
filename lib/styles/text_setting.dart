import 'package:flutter/material.dart';

class TextSetting {
  static List<Text> _buildTextVariants({
    required String text,
    required List<TextStyle?> styles,
  }) {
    return styles
        .map((styles) => Text(
              text,
              style: styles,
              textAlign: TextAlign.center,
            ))
        .toList();
  }

  static Stack _textTitle({
    required String text,
    required List<TextStyle?> textStyle,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: _buildTextVariants(text: text, styles: textStyle),
    );
  }

  static Stack textTopBarNums({
    required int puzzleNums,
    required BuildContext context,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: _buildTextVariants(
        text: puzzleNums.toString(),
        styles: [
          Theme.of(context).textTheme.headlineLarge,
          Theme.of(context).textTheme.headlineMedium,
        ],
      ),
    );
  }

  static Stack textDialogTitle({
    required String text,
    required BuildContext context,
  }) {
    return _textTitle(
      text: text,
      textStyle: [
        Theme.of(context).textTheme.titleLarge,
        Theme.of(context).textTheme.titleMedium,
      ],
    );
  }

  static Stack textDisplay({
    required String text,
    bool disable = false,
    required BuildContext context,
  }) {
    final TextStyle? textStyle;
    if (disable) {
      textStyle = Theme.of(context).textTheme.displaySmall;
    } else {
      textStyle = Theme.of(context).textTheme.displayMedium;
    }

    return _textTitle(
      text: text,
      textStyle: [textStyle],
    );
  }

  static Stack textSmall({
    required String text,
    required BuildContext context,
  }) {
    return _textTitle(
      text: text,
      textStyle: [Theme.of(context).textTheme.labelLarge],
    );
  }
}
