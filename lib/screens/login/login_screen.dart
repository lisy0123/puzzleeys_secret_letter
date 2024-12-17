import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
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
          colors: [Colors.black12, Colors.black.withOpacity(0.7)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: 100.0.w, right: 100.0.w, top: 300.0.h, bottom: 80.0.h),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildText(),
            SizedBox(height: 40.0.w),
            _buildText(text: CustomStrings.slogan),
          ],
        ),
        Image.asset('assets/imgs/login_puzzle.png', height: 400.0.w),
        Column(
          children: [
            _buildSignInButton(
              onTap: LoginScreenHandler.googleLogin,
              color: Colors.white,
              text: CustomStrings.googleLogin,
              icon: SvgPicture.asset('assets/imgs/google.svg'),
            ),
            SizedBox(height: 60.0.w),
            _buildSignInButton(
              onTap: LoginScreenHandler.appleLogin,
              color: Colors.black,
              text: CustomStrings.appleLogin,
              icon: Icon(Icons.apple, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Text _buildText({String text = 'PUZZLEEY'}) {
    final bool classify = text == 'PUZZLEEY';

    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'RIDI',
        fontSize: classify ? 260.sp : 100.sp,
        fontWeight: classify ? FontWeight.w900 : FontWeight.w500,
        letterSpacing: classify ? 6 : 2,
      ),
    );
  }

  Widget _buildSignInButton({
    required VoidCallback onTap,
    required Color color,
    required String text,
    required Widget icon,
  }) {
    final bool isGoogle = color == Colors.white;
    final Color textColor = isGoogle ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: textColor,
                fontSize: 100.sp,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
