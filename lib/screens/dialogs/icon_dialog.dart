import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/dialog_content.dart';

class IconDialog extends StatelessWidget {
  final String iconName;
  final bool overlapped;
  final Color puzzleColor;
  final bool simpleDialog;

  const IconDialog({
    super.key,
    required this.iconName,
    this.overlapped = false,
    this.puzzleColor = Colors.transparent,
    this.simpleDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => buildDialog(context),
      child: SvgPicture.asset(
        'assets/imgs/icon_$iconName.svg',
        height: 30.0.h,
      ),
    );
  }

  void buildDialog(BuildContext context) {
    showDialog(
      barrierColor: overlapped ? Colors.transparent : Colors.black54,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding:
            EdgeInsets.symmetric(horizontal: simpleDialog ? 340.0.w : 160.0.w),
        content: SizedBox(
          width: 1400.0.w,
          height: _getDialogHeight(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: DialogContent(
              iconName: iconName,
              puzzleColor: puzzleColor,
              simpleDialog: simpleDialog,
            ).buildContent(context),
          ),
        ),
      ),
    );
  }

  double _getDialogHeight() {
    if (simpleDialog) {
      return 1000.0.w;
    } else if (iconName == 'bead') {
      return 2400.0.w;
    } else {
      return 2000.0.w;
    }
  }
}
