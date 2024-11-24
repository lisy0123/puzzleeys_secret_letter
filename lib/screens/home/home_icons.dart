import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(
        top: 64.0,
        right: 24.0,
        bottom: 540.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _mainIcon(
              buttonData: _IconButtonData(iconName: 'notice'),
              context: context),
          _mainIcon(
              buttonData: _IconButtonData(iconName: 'calendar'),
              context: context),
          _mainIcon(
              buttonData: _IconButtonData(iconName: 'shop'), context: context),
          _mainIcon(
              buttonData: _IconButtonData(iconName: 'goal'), context: context),
        ],
      ),
    );
  }

  GestureDetector _mainIcon({
    required _IconButtonData buttonData,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => buttonData.onTap(context),
      child: Container(
        decoration: BoxDecorationSetting.boxDecorationMainIcon(),
        child: Image.asset(
          'assets/imgs/icon_${buttonData.iconName}.png',
          scale: 1.4,
        ),
      ),
    );
  }
}

class _IconButtonData {
  final String iconName;

  _IconButtonData({
    required this.iconName,
  });

  void onTap(BuildContext context) {
    const Map<String, String> iconRename = {
      "notice": "공 지",
      "calendar": "달 력",
      "shop": "상 점",
      "goal": "업 적",
    };

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 400.0,
            width: 320.0,
            child: Stack(
              children: [
                Image.asset(
                  'assets/imgs/background_paper.png',
                  fit: BoxFit.fill,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 40.0,
                  ),
                  alignment: Alignment.topCenter,
                  child: TextSetting.textTitle(
                    text: iconRename[iconName]!,
                    textStyle: [
                      Theme.of(context).textTheme.titleLarge,
                      Theme.of(context).textTheme.titleMedium,
                    ],
                    context: context,
                  ),
                ),
                Text('data'),
              ],
            ),
          ),
        );
      },
    );
  }
}
