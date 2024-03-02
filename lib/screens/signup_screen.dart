import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/api/enrollment_service.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/user_profile.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget with UiLoggy {
  final String programID;

  const SignupScreen({super.key, @pathParam required this.programID});

  @override
  Widget build(BuildContext context) {
    return Consumer2<EnrollmentService, UserService>(builder: (context, service, userService, child) => FutureBuilder(
      future: service.contains(programID).first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var educatorID = snapshot.data;
        if (educatorID == null) {
          FirebaseAnalytics.instance.logSignUp(signUpMethod: "From Link", parameters: {"Invalid ID": programID});
          return const Center(child: Text("Invalid sign up link."));
        }
        return RegistrationWidget(educatorID: educatorID, programID: programID);
      },
    ));
  }
}

class RegistrationWidget extends StatelessWidget with UiLoggy {
  final String educatorID;
  final String programID;

  const RegistrationWidget({super.key, required this.educatorID, required this.programID});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logSignUp(signUpMethod: "From Link", parameters: {"Valid ID": programID});
    return Consumer<UserService>(builder: (context, userService, child) => RegisterScreen(
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          var user = state.credential.user;
          if (user == null) {
            loggy.log(LogLevel.error, "Null user");
            return;
          }
          userService.createUser(UserProfile(
            id: user.uid,
            firstName: user.displayName ?? "",
            lastName: "",
            email: user.email ?? "",
            educatorID: educatorID,
            programID: programID,
          )).then((_) {
            loggy.debug("UserCreated");
            if (!state.credential.user!.emailVerified) {
              AutoRouter.of(context).push(const EmailVerifyScreenRoute());
            } else {
              FirebaseAnalytics.instance.logLogin();
              AutoRouter.of(context).push(const HomeScreenRoute());
            }
          });
        }),
      ],
    ));
  }

}