import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/providers/bar_provider.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/main_screen.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  late final StreamSubscription _authSubscription;
  bool _hasLoggedInBefore = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();

    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _initialize();
      _handleFirstLogin();
    });
  }

  Future<void> _checkFirstLogin() async {
    _hasLoggedInBefore =
        await SharedPreferencesUtils.getBool('hasLoggedInBefore') ?? false;
  }

  void _initialize() async {
    await context.read<AuthStatusProvider>().checkLoginStatus();

    final isLoggedIn =
        Supabase.instance.client.auth.currentSession?.user != null;

    if (isLoggedIn && mounted) {
      await context.read<FcmTokenProvider>().initialize();
      if (mounted) {
        await Future.wait([
          context.read<BarProvider>().initialize(context),
          context.read<BeadProvider>().initialize(),
        ]);
      }
    }
  }

  void _handleFirstLogin() async {
    final isLoggedIn =
        Supabase.instance.client.auth.currentSession?.user != null;

    if (isLoggedIn && !_hasLoggedInBefore) {
      BuildDialog.show(
        iconName: 'agreeToTerms',
        dismissible: false,
        context: context,
      );
      await SharedPreferencesUtils.saveBool('hasLoggedInBefore', true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final AuthStatusProvider authStatus = context.watch<AuthStatusProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MainScreen(),
          if (!authStatus.isLoggedIn && !authStatus.isLoading) LoginScreen(),
          if (authStatus.isLoading) PuzzleLoadingScreen(),
        ],
      ),
    );
  }
}
