import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final String version = await Utils.getAppVersion();
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText.textContentTitle(
                  text: CustomStrings.version, context: context),
              CustomText.textContent(
                  text: _version ?? '0.0.0', context: context),
              SizedBox(height: 100.0.w),
            ],
          ),
        ),
        _buildCopyRight(),
      ],
    );
  }

  Widget _buildCopyRight() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => BuildDialog.show(
              iconName: 'terms',
              overlapped: true,
              context: context,
            ),
            child: CustomText.dialogText(CustomStrings.terms, gray: true),
          ),
          SizedBox(height: 20.0.w),
          CustomText.dialogText(CustomStrings.copyRight, gray: true),
        ],
      ),
    );
  }
}
