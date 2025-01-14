import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/main_screen.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (mounted) {
        context.read<AuthStatusProvider>().checkLoginStatus();
      }
    });
    _initializeFcm();
  }

  void _initializeFcm() async {
    await context.read<FcmTokenProvider>().initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthStatusProvider>();

    return Stack(
      children: [
        MainScreen(),
        if (!authStatus.isLoggedIn && !authStatus.isLoading) LoginScreen(),
        if (authStatus.isLoading) PuzzleLoadingScreen(),
      ],
    );
  }
}
