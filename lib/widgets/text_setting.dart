import 'package:flutter/material.dart';

class TextSetting {
  static List<Text> _buildTextVariants({
    required String text,
    required List<TextStyle?> styles,
    required BuildContext context,
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
    required BuildContext context,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: _buildTextVariants(
        text: text,
        styles: textStyle,
        context: context,
      ),
    );
  }

  static Text textMainIconTitle({
    required index,
    required text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: index
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.labelMedium,
      textAlign: TextAlign.center,
    );
  }

  static Stack textIconTitle({
    required text,
    required BuildContext context,
  }) {
    return _textTitle(
      text: text,
      textStyle: [
        Theme.of(context).textTheme.titleLarge,
        Theme.of(context).textTheme.titleMedium,
      ],
      context: context,
    );
  }

  static Stack textListIconTitle({
    required text,
    required BuildContext context,
  }) {
    return _textTitle(
      text: text,
      textStyle: [
        Theme.of(context).textTheme.displayLarge,
      ],
      context: context,
    );
  }

  static Stack textPuzzleNums({
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
        context: context,
      ),
    );
  }

  static SelectableText textPuzzleContent({
    required String text,
    required BuildContext context,
  }) {
    return SelectableText(
      text,
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }
}
