import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({super.key});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  String? _userId;
  String? _userCreatedAt;
  late bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      final userData = await apiRequest('/api/user/me', ApiType.get);
      setState(() {
        _userId = userData['result']['user_id'];
        _userCreatedAt =
            Utils.convertUTCToKST(userData['result']['created_at']);
      });
    } catch (error) {
      throw Exception('Error loading user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserIdSection(context),
            SizedBox(height: 20.0.w),
            Text(
              _userId ?? '00000000000000000000==',
              style: TextStyle(
                  color: CustomColors.colorBase,
                  fontFamily: 'NANUM',
                  fontWeight: FontWeight.w900,
                  fontSize: 78.0.w),
            ),
          ],
        ),
        Utils.dialogDivider(),
        _buildBottomContent(
          firstString: CustomStrings.userCreatedAt,
          secondString: _userCreatedAt ?? '0000-00-00 00:00',
          context: context,
        ),
        Utils.dialogDivider(),
        _buildBottomContent(
          firstString: CustomStrings.userPuzzleeyDays,
          secondString:
              Utils.calculateDays(_userCreatedAt).toString().padLeft(4, '0'),
          context: context,
        ),
      ],
    );
  }

  Widget _buildUserIdSection(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          Utils.copyText(
            text: CustomStrings.userIdOverlay,
            textToCopy: _userId!,
            context: context,
          );
        });
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText.textContentTitle(
              text: CustomStrings.userId, context: context),
          SvgPicture.asset(
            height: 110.0.w,
            'assets/imgs/btn_copy.svg',
            colorFilter: ColorFilter.mode(
              _isPressed
                  ? CustomColors.colorBase.withValues(alpha: 0.2)
                  : Colors.transparent,
              BlendMode.srcATop,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent({
    required String firstString,
    required String secondString,
    required BuildContext context,
  }) {
    return Column(
      children: [
        CustomText.textContentTitle(text: firstString, context: context),
        CustomText.textContent(text: secondString, context: context),
      ],
    );
  }
}
