import 'package:auto_route/auto_route.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/routes.gr.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SignInScreen(
        actions: [
          ForgotPasswordAction((context, email) {
            Navigator.pushNamed(
              context,
              '/forgot-password',
              arguments: {'email': email},
            );
          }),
          VerifyPhoneAction((context, _) {
            Navigator.pushNamed(context, '/phone');
          }),
          AuthStateChangeAction<SignedIn>((context, state) {
            if (!state.user!.emailVerified) {
              AutoRouter.of(context).push(const EmailVerifyScreenRoute());
            } else {
              AutoRouter.of(context).push(HomeScreenRoute());
            }
          }),
          AuthStateChangeAction<UserCreated>((context, state) {
            if (!state.credential.user!.emailVerified) {
              AutoRouter.of(context).push(const EmailVerifyScreenRoute());
            } else {
              AutoRouter.of(context).push(HomeScreenRoute());
            }
          }),
          EmailLinkSignInAction((context) {
            Navigator.pushReplacementNamed(context, '/email-link-sign-in');
          }),
        ],
      ),
    );
  }


}