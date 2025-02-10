import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';

class BeadColored extends StatelessWidget {
  final List<Map<String, dynamic>>? item;

  const BeadColored({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors(item);

    return Stack(
      children: [
        Container(
          width: 800.0.w,
          height: 800.0.w,
          decoration: BoxDecorations.bead(gradientColors: gradientColors),
        ),
        Image.asset('assets/imgs/puzzle_pattern.png', width: 800.0.w),
      ],
    );
  }

  List<Color> _getGradientColors(List<Map<String, dynamic>>? item) {
    if (item == null || item.isEmpty) {
      return [Colors.white, Colors.white];
    }
    final colors = _getColors(item);

    return [
      ColorUtils.colorMatch(stringColor: colors[1]),
      ColorUtils.colorMatch(stringColor: colors[0]),
      ColorUtils.colorMatch(stringColor: colors[2]),
    ];
  }

  List<String> _getColors(List<Map<String, dynamic>>? item) {
    final colorCount = <String, int>{};
    String? topColor1, topColor2, topColor3;
    int count1 = 0, count2 = 0, count3 = 0;

    item?.forEach((element) {
      final color = element['color'];
      colorCount[color] = (colorCount[color] ?? 0) + 1;
    });

    colorCount.forEach((color, count) {
      if (count > count1) {
        count3 = count2;
        topColor3 = topColor2;
        count2 = count1;
        topColor2 = topColor1;
        count1 = count;
        topColor1 = color;
      } else if (count > count2) {
        count3 = count2;
        topColor3 = topColor2;
        count2 = count;
        topColor2 = color;
      } else if (count > count3) {
        count3 = count;
        topColor3 = color;
      }
    });

    final topEntries = <String>[];
    if (topColor1 != null) topEntries.add(topColor1!);
    if (topColor2 != null) topEntries.add(topColor2!);
    if (topColor3 != null) topEntries.add(topColor3!);

    return topEntries;
  }
}
