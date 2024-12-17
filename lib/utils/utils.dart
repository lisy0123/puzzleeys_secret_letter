import 'dart:math';
import 'package:flutter/material.dart';

class Utils {
  static void dismissKeyboard({required FocusNode focusNode}) {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  String generateRandomUserId() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random rand = Random();

    return List.generate(
        15, (index) => characters[rand.nextInt(characters.length)]).join();
  }
}
