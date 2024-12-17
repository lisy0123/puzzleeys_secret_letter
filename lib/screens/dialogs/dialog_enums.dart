import 'package:flutter/cupertino.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/get_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/account_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list/list_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/put_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/sent_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/warning_dialog.dart';

enum DialogType {
  list,
  get,
  put,
  sent,
  emptyName,
  emptyPuzzle,
  cancel,
  limit,
  bead,
  alarm,
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
      case DialogType.list:
        return ListDialog();
      case DialogType.get:
        return GetDialog(puzzleColor: puzzleColor);
      case DialogType.put:
        return PutDialog(puzzleColor: puzzleColor);
      case DialogType.sent:
        return SentDialog();
      case DialogType.cancel:
        return WarningDialog(dialogType: 0);
      case DialogType.limit:
        return WarningDialog(dialogType: 1);
      case DialogType.emptyName:
        return WarningDialog(dialogType: 2);
      case DialogType.emptyPuzzle:
        return WarningDialog(dialogType: 3);
      case DialogType.list0:
        return AccountDialog();
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
