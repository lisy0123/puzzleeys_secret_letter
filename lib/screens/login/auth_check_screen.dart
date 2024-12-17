import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:puzzleeys_secret_letter/screens/main_screen.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_screen.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  late final StreamSubscription authSubscription;
  bool isLoggedIn = false;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final storedToken = await _secureStorage.read(key: 'auth_token');
    if (storedToken != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
          _handleAuthStateChange(event);
        });
  }

  Future<void> _handleAuthStateChange(AuthState event) async {
    final accessToken = event.session?.accessToken;
    if (accessToken != null) {
      await _secureStorage.write(key: 'auth_token', value: accessToken);
    } else {
      await _secureStorage.delete(key: 'auth_token');
    }

    if (mounted) {
      setState(() {
        isLoggedIn = event.session != null;
      });
    }
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainScreen(),
        if (!isLoggedIn) LoginScreen(),
      ],
    );
  }
}
