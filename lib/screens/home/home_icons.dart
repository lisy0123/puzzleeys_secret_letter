import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/widgets/home/home_button.dart';

class HomeIcons extends StatelessWidget {
  const HomeIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(
        top: 60.0,
        right: 24.0,
        bottom: 560.0,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HomeButton(iconName: 'notice'),
          HomeButton(iconName: 'calendar'),
          HomeButton(iconName: 'shop'),
          HomeButton(iconName: 'goal'),
        ],
      ),
    );
  }
}
