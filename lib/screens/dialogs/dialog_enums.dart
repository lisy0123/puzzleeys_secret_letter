import 'package:flutter/cupertino.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/bead_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/question_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/terms_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/simple/delete_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/my_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/account_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/list_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/mission_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/quest_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/setting_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/put_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/set_days_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/show_receiver_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/puzzle_subject_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/simple/report/report_bead_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/simple/report/report_post_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/simple/user_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/simple/warning_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/simple/welcome_dialog.dart';

enum DialogType {
  bead,
  list,
  puzzlePreview,
  puzzleSubject,

  reportBead,
  reportPost,
  delete,
  cancel,
  limit,
  emptyName,
  emptyPuzzle,
  isExists,

  putGlobal,
  putSubject,
  putWho,
  putPersonal,
  putMe,
  putReply,
  setDays,

  welcome,
  logout,
  deleteUser,
  terms,

  list0,
  list1,
  list2,
  list3,
  list4,
  list5,
  list6,
  list7,
  list8;

  Widget showDialog(
    String? puzzleId,
    Color? puzzleColor,
    String? puzzleText,
    Map<String, dynamic>? puzzleData,
    PuzzleType? puzzleType,
  ) {
    switch (this) {
      case DialogType.bead:
        return BeadDialog();
      case DialogType.list:
        return ListDialog();
      case DialogType.puzzleSubject:
        return PuzzleSubjectDialog(
          puzzleColor: puzzleColor!,
          puzzleText: puzzleText!,
        );

      case DialogType.reportBead:
        return ReportBeadDialog(puzzleId: puzzleId!, puzzleType: puzzleType!);
      case DialogType.reportPost:
        return ReportPostDialog(puzzleId: puzzleId!, puzzleType: puzzleType!);
      case DialogType.delete:
        return DeleteDialog(puzzleId: puzzleId!);
      case DialogType.cancel:
        return WarningDialog(dialogType: WarningType.cancel);
      case DialogType.limit:
        return WarningDialog(dialogType: WarningType.limit);
      case DialogType.emptyName:
        return WarningDialog(dialogType: WarningType.emptyName);
      case DialogType.emptyPuzzle:
        return WarningDialog(dialogType: WarningType.emptyPuzzle);
      case DialogType.isExists:
        return WarningDialog(dialogType: WarningType.isExists);

      case DialogType.putGlobal:
        return PutDialog(
          puzzleData: puzzleData!,
          puzzleType: PuzzleType.global,
        );
      case DialogType.putSubject:
        return PutDialog(
          puzzleData: puzzleData!,
          puzzleType: PuzzleType.subject,
        );
      case DialogType.putWho:
        return ShowReceiverDialog();
      case DialogType.putPersonal:
        return PutDialog(
          puzzleData: puzzleData!,
          puzzleType: PuzzleType.personal,
        );
      case DialogType.putMe:
        return PutDialog(
          puzzleData: puzzleData!,
          puzzleType: PuzzleType.me,
        );
      case DialogType.putReply:
        return PutDialog(
          puzzleData: puzzleData!,
          puzzleType: PuzzleType.reply,
        );
      case DialogType.setDays:
        return SetDaysDialog(puzzleData: puzzleData!);

      case DialogType.welcome:
        return WelcomeDialog();
      case DialogType.logout:
        return UserDialog(deleteUser: false);
      case DialogType.deleteUser:
        return UserDialog(deleteUser: true);
      case DialogType.terms:
        return TermsDialog();

      case DialogType.list0:
        return AccountDialog();
      case DialogType.list1:
        return MyDialog();
      case DialogType.list3:
        return MissionDialog();
      case DialogType.list5:
        return QuestDialog();
      case DialogType.list7:
        return QuestionDialog();
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
  final String? puzzleId;
  final Color? puzzleColor;
  final String? puzzleText;
  final Map<String, dynamic>? puzzleData;
  final PuzzleType? puzzleType;

  const DialogEnums({
    super.key,
    required this.iconName,
    this.puzzleId,
    this.puzzleColor,
    this.puzzleText,
    this.puzzleData,
    this.puzzleType,
  });

  @override
  Widget build(BuildContext context) {
    final DialogType dialogType = DialogTypeExtension.fromString(
        (RegExp(r'^[0-8]$').hasMatch(iconName)) ? 'list$iconName' : iconName);
    return dialogType.showDialog(
      puzzleId,
      puzzleColor,
      puzzleText,
      puzzleData,
      puzzleType,
    );
  }
}
