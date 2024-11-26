import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class HomeButton extends StatelessWidget {
  final String iconName;

  const HomeButton({
    super.key,
    this.iconName = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: _build(),
    );
  }

  Widget _build() {
    if (iconName == 'setting') {
      return Container(
        margin: const EdgeInsets.only(right: 32.0),
        child: SvgPicture.asset(
          'assets/imgs/icon_setting.svg',
          height: 18.0,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecorationSetting.boxDecorationIcon(),
        child: SvgPicture.asset(
          'assets/imgs/icon_home_$iconName.svg',
          height: 40.0,
        ),
      );
    }
  }

  void onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: (iconName == "setting" || iconName == "") ? 440.0 : 360.0,
            width: iconName == "" ? 400.0 : 260.0,
            child: Stack(
              alignment: Alignment.topCenter,
              children: _drawContent(context),
              // children: _onTapContent()._drawContent(context),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _drawContent(BuildContext context) {
    return ([
      Container(
        margin: const EdgeInsets.only(top: 16.0),
        decoration: BoxDecorationSetting.boxDecorationHomeAlertDialog(),
      ),
      SvgPicture.asset(
        'assets/imgs/background_tape.svg',
        height: 36.0,
      ),
      _drawContentTitle(context),
    ]);
  }

  Widget _drawContentTitle(BuildContext context) {
    const Map<String, String> iconNameLists = {
      "setting": "설 정",
      "0": "공 지",
      "1": "구슬  달력",
      "2": "상 점",
      "3": "업 적",
      "": "감정 퍼즐 구슬",
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40.0),
        Container(
          child: TextSetting.textIconTitle(
            text: iconNameLists[iconName],
            context: context,
          ),
        ),
        const SizedBox(height: 16.0),
        const DottedDivider(),
      ],
    );
  }
}
