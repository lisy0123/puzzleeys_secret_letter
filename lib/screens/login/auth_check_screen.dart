import 'package:flutter/cupertino.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
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
    context.read<AuthStatusProvider>().checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthStatusProvider>().isLoggedIn;

    return Stack(
      children: [
        MainScreen(),
        if (!isLoggedIn) LoginScreen(),
      ],
    );
  }
}
