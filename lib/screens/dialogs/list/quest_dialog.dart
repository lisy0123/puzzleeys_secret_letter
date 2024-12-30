import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class QuestDialog extends StatefulWidget {
  const QuestDialog({super.key});

  @override
  State<QuestDialog> createState() => _QuestDialogState();
}

class _QuestDialogState extends State<QuestDialog> {
  final List<Enum> _quests = [
    QuestType.attendance,
    QuestType.writePuzzle,
    QuestType.getPuzzle,
    QuestType.writeReply,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _quests
          .map((quest) => Column(
                children: [
                  _buildContent(quest: quest, context: context),
                  if (quest != _quests.last) Utils.dialogDivider(),
                ],
              ))
          .toList(),
    );
  }

  Widget _buildContent({
    required Enum quest,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0.w, right: 20.0.w),
      child: SizedBox(
        height: 340.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildText(quest, context),
            CustomButton(
              iconName: 'bar_dia',
              iconHeight: 20.0,
              iconTitle: 10.toString(),
              iconTopTitle: CustomStrings.questButtons[false]!,
              height: 260.0,
              width: 380.0,
              borderStroke: 1.3,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(Enum quest, BuildContext context) {
    final QuestData questData = CustomVars.questDatabases[quest]!;
    final String goal = quest == QuestType.attendance
        ? '${questData.goal}${CustomStrings.questUnits[0]}'
        : '${questData.goal}${CustomStrings.questUnits[1]}';
    final String progress = quest == QuestType.attendance
        ? questData.count.toString()
        : questData.count.toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.textContent(
          text: '${MessageStrings.questMessages[quest]} $goal',
          context: context,
        ),
        CustomText.textContent(text: '$progress/$goal', context: context),
      ],
    );
  }
}
