import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/main_screen.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthStatusProvider>().checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthStatusProvider>();
    final isLoggedIn = authStatus.isLoggedIn;
    final isLoading = authStatus.isLoading;

    return Stack(
      children: [
        MainScreen(),
        if (!isLoggedIn) LoginScreen(),
        if (isLoading)
          PuzzleLoadingScreen(
              text: MessageStrings.loadingMessages[LoadingType.login]!),
      ],
    );
  }
}
