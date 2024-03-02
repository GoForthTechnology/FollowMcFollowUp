import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/api/enrollment_service.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/user_profile.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final String programID;

  const SignupScreen({super.key, @pathParam required this.programID});

  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  bool ready = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<EnrollmentService, UserService>(builder: (context, service, userService, child) => FutureBuilder(
      future: service.contains(widget.programID).first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var educatorID = snapshot.data;
        if (educatorID == null) {
          FirebaseAnalytics.instance.logSignUp(signUpMethod: "From Link", parameters: {"Invalid ID": widget.programID});
          return const Center(child: Text("Invalid sign up link."));
        }
        if (ready) {
          return RegistrationWidget(
            educatorID: educatorID,
            programID: widget.programID,
            email: emailController.text,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text("FC Classroom")),
          body: Center(child: Column(children: [
            const Padding(padding: EdgeInsets.all(20), child: Text("Welcome to FC Classroom")),
            const Padding(padding: EdgeInsets.all(20), child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris facilisis purus id turpis sollicitudin, non viverra justo facilisis. Nulla lectus ligula, dictum eget lacus sit amet, placerat facilisis ex. Nullam in turpis magna. Donec quis augue sit amet orci varius suscipit. Aenean molestie auctor dictum. Etiam viverra ex est, id auctor purus molestie eget. Suspendisse potenti. Nunc laoreet auctor congue. Sed ac venenatis ipsum, nec rutrum urna. In vel velit luctus, ultrices purus quis, hendrerit ante. Etiam imperdiet lacinia porta. Vestibulum non lacus turpis. Cras vehicula volutpat lacus, ac finibus erat posuere gravida. Donec nulla est, malesuada nec mi sed, porttitor malesuada nulla. Praesent augue lorem, semper at augue at, malesuada efficitur lectus.")),
            ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (context) => RegistrationDialog(
                emailController: emailController,
                firstNameController: firstNameController,
                lastNameController: lastNameController,
              )).then((_) => setState(() {
                ready = true;
              }));
            }, child: const Text("Click here to get started")),
          ])),
        );
      },
    ));
  }

}

class RegistrationDialog extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();

  RegistrationDialog({super.key, required this.firstNameController, required this.lastNameController, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Account"),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "First Name"),
            controller: firstNameController,
            validator: (value) => (value != "") ? null : "Value Required!",
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Last Name"),
            controller:  lastNameController,
            validator: (value) => (value != "") ? null : "Value Required!",
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            controller:  emailController,
            validator: (value) => (value != "") ? null : "Value Required!",
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: const Text("Cancel")),
        TextButton(onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).pop();
          }
        }, child: const Text("Submit")),
      ],
    );
  }
}

class RegistrationWidget extends StatelessWidget with UiLoggy {
  final String educatorID;
  final String programID;
  final String email;
  final String firstName;
  final String lastName;

  const RegistrationWidget({super.key, required this.educatorID, required this.programID, required this.email, required this.firstName, required this.lastName});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logSignUp(signUpMethod: "From Link", parameters: {"Valid ID": programID});
    return Consumer<UserService>(builder: (context, userService, child) => RegisterScreen(
      email: email,
      showAuthActionSwitch: false,
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) => onUserCreated(context, state, userService)),
      ],
    ));
  }

  void onUserCreated(BuildContext context, UserCreated state, UserService userService) {
    var user = state.credential.user;
    if (user == null) {
      loggy.log(LogLevel.error, "Null user");
      return;
    }
    userService.createUser(UserProfile(
      id: user.uid,
      firstName: firstName,
      lastName: lastName,
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
  }
}