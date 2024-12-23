import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class MissionDialog extends StatelessWidget {
  const MissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildMissionList(context),
        SizedBox(height: 60.0.w),
        CustomButton(
          iconName: 'bar_dia',
          iconHeight: 28.0,
          iconTitle: 10.toString(),
          height: 200.0,
          width: 480.0,
          borderStroke: 1.3,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMissionList(BuildContext context) {
    final missions = [
      MissionType.attendance,
      MissionType.writeSubjectPuzzle,
      MissionType.writeGlobalPersonalPuzzle,
      MissionType.getPuzzle,
      MissionType.writeReply,
    ];

    return Column(
      children: List.generate(missions.length, (index) {
        return Column(
          children: [
            _buildContent(
              index: index + 1,
              missionType: missions[index],
              context: context,
            ),
            Utils.dialogDivider(),
          ],
        );
      }),
    );
  }

  Widget _buildContent({
    required int index,
    required Enum missionType,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.0.w, vertical: 45.0.w),
      child: Row(
        children: [
          Text(
            '$index. ${CustomStrings.missionMessages[missionType]!}',
            style: TextStyle(
              color: CustomColors.colorBase.withValues(alpha: 0.5),
              fontSize: 80.0.sp,
              fontFamily: 'NANUM',
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              height: 1.8,
              decoration: TextDecoration.lineThrough,
              decorationColor: CustomColors.colorBase.withValues(alpha: 0.5),
              decorationThickness: 4.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
