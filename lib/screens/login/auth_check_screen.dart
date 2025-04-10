import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
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

class _AuthCheckScreenState extends State<AuthCheckScreen>
    with WidgetsBindingObserver {
  late final StreamSubscription _authSubscription;
  late BarProvider _barProvider;
  late BeadProvider _beadProvider;
  late final LoggedBeforeProvider _loggedBeforeProvider;
  DateTime? _lastUpdatedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _verifyVersion();
      await _checkIOSTrackingPermission();
    });

    if (mounted) {
      _beadProvider = context.read<BeadProvider>();
      _barProvider = context.read<BarProvider>();
      _loggedBeforeProvider = context.read<LoggedBeforeProvider>();
    }

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

  Future<void> _verifyVersion() async {
    await AppVersionUpdate.checkForUpdates(
      appleId: dotenv.env['APPLE_APP_ID'],
      // playStoreId: dotenv.env['PLAY_STORE_ID'],
      country: 'kr',
    ).then((result) async {
      if (result.canUpdate! && mounted) {
        BuildDialog.show(
          iconName: 'update',
          puzzleText: result.storeUrl,
          simpleDialog: true,
          dismissible: false,
          context: context,
        );
      }
    });
  }

  Future<void> _checkIOSTrackingPermission() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      // final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    } catch (error) {
      debugPrint('checkIOSTracking Error: $error');
    }
  }

  void _initialize() async {
    await context.read<AuthStatusProvider>().checkLoginStatus();

    final bool isLoggedIn =
        Supabase.instance.client.auth.currentSession?.user != null;

    if (isLoggedIn && mounted) {
      await context.read<FcmTokenProvider>().initialize();
      if (mounted) {
        await Future.wait([
          _barProvider.initialize(context),
          _beadProvider.initialize(),
        ]);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime lastUpdated = _lastUpdatedDate ?? today;

      if (today.isAfter(lastUpdated)) {
        _lastUpdatedDate = today;
        if (mounted) {
          await Future.wait([
            _barProvider.initialize(context),
            _beadProvider.initialize(),
          ]);
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription.cancel();
    super.dispose();
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
