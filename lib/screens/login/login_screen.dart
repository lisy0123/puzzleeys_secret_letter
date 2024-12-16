import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black12, Colors.black54],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.0.w, vertical: 200.0.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildTitle(context),
            _buildSignInButtons(context),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(_userId ?? 'Not signed in'),
    //         ElevatedButton(
    //           onPressed: () async {
    //             final webClientId = dotenv.env['WED_ID'];
    //             final iosClientId = dotenv.env['IOS_ID'];
    //
    //             final GoogleSignIn googleSignIn = GoogleSignIn(
    //               clientId: iosClientId,
    //               serverClientId: webClientId,
    //             );
    //             final googleUser = await googleSignIn.signIn();
    //             final googleAuth = await googleUser!.authentication;
    //             final accessToken = googleAuth.accessToken;
    //             final idToken = googleAuth.idToken;
    //
    //             if (accessToken == null) {
    //               throw 'No Access Token found.';
    //             }
    //             if (idToken == null) {
    //               throw 'No ID Token found.';
    //             }
    //
    //             await supabase.auth.signInWithIdToken(
    //               provider: OAuthProvider.google,
    //               idToken: idToken,
    //               accessToken: accessToken,
    //             );
    //           },
    //           child: Text('Sign in with Google'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      height: 2000.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'PUZZLEEY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 240.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: 20.0.w),
              Text(
                '퍼즐에 감정을 담다',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 100.sp,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/imgs/login_puzzle.png',
            height: 400.0.w,
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/imgs/google.svg'),
              SizedBox(width: 50.0.w),
              Text(
                '구글로 시작하기',
                style: TextStyle(color: Colors.black, fontSize: 100.sp),
              ),
            ],
          ),
        ),
        SizedBox(height: 100.0.w),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apple, color: Colors.white),
              SizedBox(width: 50.0.w),
              Text(
                '애플로 시작하기',
                style: TextStyle(color: Colors.white, fontSize: 100.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
