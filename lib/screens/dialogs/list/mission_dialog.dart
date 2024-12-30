import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class MissionDialog extends StatefulWidget {
  const MissionDialog({super.key});

  @override
  State<MissionDialog> createState() => _MissionDialogState();
}

class _MissionDialogState extends State<MissionDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMissionList(context),
          CustomButton(
            iconName: 'bar_dia',
            iconHeight: 20.0,
            iconTitle: 10.toString(),
            iconTopTitle: CustomStrings.questButtons[true]!,
            height: 260.0,
            width: 560.0,
            borderStroke: 1.3,
            onTap: () {},
          ),
        ],
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 80.0.w, vertical: 36.0.w),
      child: Row(
        children: [
          Text(
            '$index. ${MessageStrings.missionMessages[missionType]!}',
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
