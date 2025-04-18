import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/logged_before_provider.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_screen_handler.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Colors.black12, Colors.black.withValues(alpha: 0.6)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.0.w)
            .copyWith(top: 450.0.h, bottom: 60.0.h),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final LoggedBeforeProvider loggedBeforeProvider =
        context.read<LoggedBeforeProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildText(text: CustomStrings.title, isMainTitle: true),
            _buildText(text: CustomStrings.slogan),
          ],
        ),
        Column(
          children: [
            _buildSignInButton(
              onTap: () async {
                bool isExist = await LoginScreenHandler.googleLogin(context);
                loggedBeforeProvider.loggedCheckToggle(isExist);
              },
              color: Colors.white,
              text: CustomStrings.googleLogin,
              icon: SvgPicture.asset('assets/imgs/google.svg'),
            ),
            SizedBox(height: 60.0.w),
            _buildSignInButton(
              onTap: () async {
                bool isExist = await LoginScreenHandler.appleLogin(context);
                loggedBeforeProvider.loggedCheckToggle(isExist);
              },
              color: Colors.black,
              text: CustomStrings.appleLogin,
              icon: Icon(Icons.apple, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText({required String text, bool isMainTitle = false}) {
    return Stack(
      children: [
        _buildStrokedText(
          text: text,
          fontSize: isMainTitle ? 260.sp : 100.sp,
          fontFamily: 'NANUM',
          strokeWidth: isMainTitle ? 6 : 4,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'NANUM',
            fontSize: isMainTitle ? 260.sp : 100.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: isMainTitle ? 4 : 2,
          ),
        ),
      ],
    );
  }

  Widget _buildStrokedText({
    required String text,
    required double fontSize,
    required String fontFamily,
    required double strokeWidth,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: fontSize == 260.sp ? 4 : 2,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = CustomColors.colorBase,
      ),
    );
  }

  Widget _buildSignInButton({
    required VoidCallback onTap,
    required Color color,
    required String text,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 320.0.w,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 50.0.w),
            Text(
              text,
              style: TextStyle(
                color: color == Colors.white ? Colors.black : Colors.white,
                fontFamily: 'NANUM',
                fontWeight: FontWeight.w900,
                fontSize: 94.sp,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
