import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/dialog_content.dart';

class IconDialog extends StatelessWidget {
  final String iconName;

  const IconDialog({
    super.key,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BuildDialog.show(
        iconName: iconName,
        context: context,
      ),
      child: SvgPicture.asset(
        'assets/imgs/icon_$iconName.svg',
        height: 32.0.h,
      ),
    );
  }
}

class BuildDialog {
  static void show({
    required String iconName,
    Color? puzzleColor,
    String? puzzleText,
    Map<String, dynamic>? puzzleData,
    PuzzleType? puzzleType,
    String? puzzleId,
    bool overlapped = false,
    bool simpleDialog = false,
    required BuildContext context,
  }) {
    showDialog(
      barrierColor: overlapped ? Colors.transparent : Colors.black54,
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: simpleDialog ? 360.0.w : 160.0.w,
          ),
          content: SizedBox(
            width: 1400.0.w,
            height: _getDialogHeight(iconName, simpleDialog),
            child: Stack(
              alignment: Alignment.topCenter,
              children: DialogContent(
                iconName: iconName,
                puzzleId: puzzleId,
                puzzleColor: puzzleColor,
                puzzleText: puzzleText,
                puzzleData: puzzleData,
                puzzleType: puzzleType,
                simpleDialog: simpleDialog,
              ).buildContent(context),
            ),
          ),
        );
      },
    );
  }

  static double _getDialogHeight(String iconName, bool simpleDialog) {
    if (simpleDialog) {
      return 1000.0.w;
    } else if (iconName == 'bead') {
      return 3000.0.w;
    } else {
      return 2000.0.w;
    }
  }
}
