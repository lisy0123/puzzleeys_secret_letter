import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDialog extends StatelessWidget {
  final bool deleteUser;

  const UserDialog({super.key, required this.deleteUser});

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: deleteUser
          ? MessageStrings.deleteUserMessage
          : MessageStrings.logoutMessage,
      iconName: 'btn_door',
      iconTitle: deleteUser ? CustomStrings.deleteUser : CustomStrings.logout,
      onTap: () => deleteUser ? _deleteUser(context) : _logout(context),
    );
  }

  void _logout(BuildContext context) async {
    final responseData = await context.read<FcmTokenProvider>().deleteFcm();
    if (responseData['code'] == 200 && context.mounted) {
      await _clear(context);
    }
  }

  void _deleteUser(BuildContext context) async {
    try {
      final responseData =
          await apiRequest('/api/auth/delete_user', ApiType.delete);
      if (responseData['code'] == 200 && context.mounted) {
        await _clear(context);
      }
    } catch (error) {
      throw Exception("Error deleting user: $error");
    }
  }

  Future<void> _clear(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    await Future.wait([
      SecureStorageUtils.clear(),
      SharedPreferencesUtils.clear(),
      Hive.deleteFromDisk(),
    ]);
    if (context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
