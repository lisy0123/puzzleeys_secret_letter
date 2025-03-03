import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/providers/bar_provider.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/providers/logged_before_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
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
  late final LoggedBeforeProvider _loggedBeforeProvider;

  @override
  void initState() {
    super.initState();
    _loggedBeforeProvider = context.read<LoggedBeforeProvider>();

    _loggedBeforeProvider.addListener(() {
      if (!_loggedBeforeProvider.loggedInBefore) {
        BuildDialog.show(
          iconName: 'agreeToTerms',
          dismissible: false,
          context: context,
        );
        _loggedBeforeProvider.loggedCheckToggle(true);
      }
    });

    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _initialize();
    });
  }

  void _initialize() async {
    await context.read<AuthStatusProvider>().checkLoginStatus();

    final bool isLoggedIn =
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
