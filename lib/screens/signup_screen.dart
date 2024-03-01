import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/api/enrollment_service.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final String programID;

  const SignupScreen({super.key, @pathParam required this.programID});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnrollmentService>(builder: (context, service, child) => FutureBuilder(
      future: service.contains(programID).first,
      builder: (context, snapshot) {
        var validID = snapshot.data ?? false;
        if (!validID) {
          FirebaseAnalytics.instance.logSignUp(signUpMethod: "From Link", parameters: {"Invalid ID": programID});
          return const Text("Invalid ID");
        }
        FirebaseAnalytics.instance.logSignUp(signUpMethod: "From Link", parameters: {"Valid ID": programID});
        return RegisterScreen(
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              if (!state.user!.emailVerified) {
                AutoRouter.of(context).push(const EmailVerifyScreenRoute());
              } else {
                AutoRouter.of(context).pushAndPopUntil(const HomeScreenRoute(), predicate: (r) => false);
              }
            }),
            AuthStateChangeAction<UserCreated>((context, state) {
              if (!state.credential.user!.emailVerified) {
                AutoRouter.of(context).push(const EmailVerifyScreenRoute());
              } else {
                FirebaseAnalytics.instance.logLogin();
                AutoRouter.of(context).push(const HomeScreenRoute());
              }
            }),
          ],
        );
      },
    ));
  }
}