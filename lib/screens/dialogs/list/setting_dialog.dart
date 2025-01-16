import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
// import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                text: CustomStrings.version,
                context: context,
              ),
              CustomText.textContent(
                  text: _version ?? '0.0.0', context: context),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: _deleteUser,
            child: CustomText.textSmall(
              text: '[ ${CustomStrings.deleteUser} ]',
              context: context,
            ),
          ),
          // Using for debug
          // CustomButton(
          //   iconName: 'none',
          //   iconTitle: CustomStrings.logout,
          //   onTap: _logout,
          // ),
        ),
      ],
    );
  }

  Future<void> _deleteUser() async {
    try {
      final responseData =
          await apiRequest('/api/auth/delete_user', ApiType.delete);
      if (responseData['code'] == 200) {
        _clear();
      }
    } catch (error) {
      throw Exception("Error deleting user: $error");
    }
  }

  Future<void> _clear() async {
    await Future.wait([
      Supabase.instance.client.auth.signOut(),
      SecureStorageUtils.clear(),
    ]);
    if (mounted) {
      context.read<AuthStatusProvider>().checkLoginStatus();
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  // Using for debug
  // Future<void> _logout() async {
  //   final responseData = await context.read<FcmTokenProvider>().deleteFcm();
  //   if (responseData['code'] == 200) {
  //     _clear();
  //   }
  // }
}
