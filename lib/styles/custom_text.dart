import 'package:flutter/material.dart';

class CustomText {
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
    bool stroke = false,
    required BuildContext context,
  }) {
    final List<TextStyle?> textStyle;
    if (disable) {
      textStyle = [Theme.of(context).textTheme.displaySmall];
    } else {
      if (stroke) {
        textStyle = [
          Theme.of(context).textTheme.bodySmall,
          Theme.of(context).textTheme.displayMedium,
        ];
      } else {
        textStyle = [Theme.of(context).textTheme.displayMedium];
      }
    }

    return _textTitle(text: text, textStyle: textStyle);
  }

  static Text textSmall({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  static Text textContent({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }

  static Text textContentTitle({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall,
      textAlign: TextAlign.center,
    );
  }
}
