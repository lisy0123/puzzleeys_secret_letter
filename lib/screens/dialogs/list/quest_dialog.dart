import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
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
    final QuestData questData = CustomStrings.questDatabases[quest]!;
    final String index = quest == QuestType.attendance
        ? '${questData.count}/${questData.goal}${CustomStrings.questUnit[0]}'
        : '${questData.count}/${questData.goal}${CustomStrings.questUnit[1]}';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.0.w),
      child: SizedBox(
        height: 360.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.textContent(
                  text: CustomStrings.questMessages[quest]!,
                  context: context,
                ),
                CustomText.textContent(text: index, context: context),
              ],
            ),
            CustomButton(
              iconName: 'bar_dia',
              iconHeight: 26.0,
              iconTitle: 10.toString(),
              height: 200.0,
              width: 400.0,
              borderStroke: 1.3,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
