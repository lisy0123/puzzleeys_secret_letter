import 'package:flutter/cupertino.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/bead_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/get_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/account_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/list_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/mission_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/quest_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/setting_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/put_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/set_days_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/show_receiver_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/warning_dialog.dart';

enum DialogType {
  list,
  get,
  cancel,
  limit,
  bead,
  alarm,
  emptyName,
  emptyPuzzle,
  putGlobal,
  putSubject,
  putWho,
  putPersonal,
  putMe,
  putReply,
  setDays,
  list0,
  list1,
  list2,
  list3,
  list4,
  list5,
  list6,
  list7,
  list8;

  Widget showDialog(Color puzzleColor) {
    switch (this) {
      case DialogType.bead:
        return BeadDialog();
      case DialogType.list:
        return ListDialog();
      case DialogType.get:
        return GetDialog(puzzleColor: puzzleColor);
      case DialogType.cancel:
        return WarningDialog(dialogType: WarningType.cancel);
      case DialogType.limit:
        return WarningDialog(dialogType: WarningType.limit);
      case DialogType.emptyName:
        return WarningDialog(dialogType: WarningType.emptyName);
      case DialogType.emptyPuzzle:
        return WarningDialog(dialogType: WarningType.emptyPuzzle);

      case DialogType.putGlobal:
        return PutDialog(
          puzzleColor: puzzleColor,
          puzzleType: PuzzleType.global,
        );
      case DialogType.putSubject:
        return PutDialog(
          puzzleColor: puzzleColor,
          puzzleType: PuzzleType.subject,
        );
      case DialogType.putWho:
        return ShowReceiverDialog();
      case DialogType.putPersonal:
        return PutDialog(
          puzzleColor: puzzleColor,
          puzzleType: PuzzleType.personal,
        );
      case DialogType.putMe:
        return PutDialog(
          puzzleColor: puzzleColor,
          puzzleType: PuzzleType.me,
        );
      case DialogType.putReply:
        return PutDialog(
          puzzleColor: puzzleColor,
          puzzleType: PuzzleType.reply,
        );
      case DialogType.setDays:
        return SetDaysDialog();

      case DialogType.list0:
        return AccountDialog();
      case DialogType.list3:
        return MissionDialog();
      case DialogType.list5:
        return QuestDialog();
      case DialogType.list8:
        return SettingDialog();
      default:
        return Placeholder();
    }
  }
}

extension DialogTypeExtension on DialogType {
  static DialogType fromString(String name) {
    return DialogType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError("Invalid name: $name"),
    );
  }
}

class DialogEnums extends StatelessWidget {
  final String iconName;
  final Color puzzleColor;

  const DialogEnums({
    super.key,
    required this.iconName,
    required this.puzzleColor,
  });

  @override
  Widget build(BuildContext context) {
    final DialogType dialogType = DialogTypeExtension.fromString(
        (RegExp(r'^[0-8]$').hasMatch(iconName)) ? 'list$iconName' : iconName);
    return dialogType.showDialog(puzzleColor);
  }
}
