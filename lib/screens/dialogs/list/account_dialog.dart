import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({super.key});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  late final StreamSubscription authSubscription;
  String? _userEmail;
  String? _userId;

  @override
  void initState() {
    super.initState();
    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (mounted) {
        setState(() {
          _userEmail = event.session?.user.email;
          _userId = event.session?.user.id;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '아이디',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          _userEmail ?? 'Not Sign In',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          '회원 번호',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          _userId ?? 'Not Sign In',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(
          child: CustomButton(
              iconName: 'list_0',
              iconTitle: CustomStrings.logout,
              onTap: () {
                Supabase.instance.client.auth.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
        ),
      ],
    );
  }
}
