import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';

class PuzzleIcons extends StatelessWidget {
  const PuzzleIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60.0, left: 80.0),
      alignment: Alignment.topCenter,
      child: Stack(
        // alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecorationSetting.boxDecorationIcon(),
            child: SvgPicture.asset(
              'assets/imgs/navigation_bar.svg',
              height: 54.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => back(context),
                  child: SvgPicture.asset(
                    'assets/imgs/icon_home.svg',
                    height: 24.0,
                  ),
                ),
                SizedBox(width: 24.0),
                GestureDetector(
                  onTap: () => back(context),
                  child: SvgPicture.asset(
                    'assets/imgs/icon_personal.svg',
                    height: 24.0,
                  ),
                ),
                SizedBox(width: 24.0),
                GestureDetector(
                  onTap: () => back(context),
                  child: SvgPicture.asset(
                    'assets/imgs/icon_global.svg',
                    height: 24.0,
                  ),
                ),
                SizedBox(width: 24.0),
                GestureDetector(
                  onTap: () => back(context),
                  child: SvgPicture.asset(
                    'assets/imgs/icon_subject.svg',
                    height: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void back(BuildContext context) {
    debugPrint("Next Page!");
    Navigator.pop(context);
  }
}
