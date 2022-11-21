import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/routes.gr.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(
      actionCodeSettings: ActionCodeSettings(
        url: 'https://app.bloomcyclecare.com',
        handleCodeInApp: true,
      ),
      actions: [
        EmailVerifiedAction(() {
          AutoRouter.of(context).push(HomeScreenRoute());
        }),
        AuthCancelledAction((context) {
          FirebaseUIAuth.signOut(context: context);
          AutoRouter.of(context).push(const LoginScreenRoute());
        }),
      ],
    );
  }
}