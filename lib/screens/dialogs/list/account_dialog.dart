import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({super.key});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  late final StreamSubscription authSubscription;
  String? _userId;
  String? _userCreatedAt;
  late bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (mounted) {
        _userData(event.session!.user.email);
      }
    });
  }

  Future<void> _userData(String? email) async {
    if (email != null) {
      final userResponse = await Supabase.instance.client
          .from('user_list')
          .select()
          .eq('email', email)
          .single();

      if (mounted) {
        setState(() {
          _userId = userResponse['id'];
          _userCreatedAt = Utils.convertUTCToKST(userResponse['created_at']);
        });
      } else {
        throw "Error: $userResponse";
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.0.w, bottom: 20.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) {
                  setState(() {
                    _isPressed = false;
                  });
                },
                onTapCancel: () => setState(() => _isPressed = false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText.textContent(text: '회원 번호', context: context),
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
              ),
              SizedBox(height: 20.0.w),
              CustomText.textContent(
                text: _userId ?? '',
                context: context,
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.textContent(text: '버전:', context: context),
                  CustomText.textContent(
                    text: CustomVars.version,
                    context: context,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.textContent(text: '가입 날짜:', context: context),
                  CustomText.textContent(
                    text: _userCreatedAt ?? '',
                    context: context,
                  ),
                ],
              ),
            ],
          ),
          // CustomButton(
          //   iconName: 'none',
          //   iconTitle: CustomStrings.logout,
          //   onTap: () async {
          //     await Supabase.instance.client.auth.signOut();
          //     Future.delayed(Duration.zero, () {
          //       if (context.mounted) {
          //         Navigator.popUntil(context, (route) => route.isFirst);
          //       }
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
