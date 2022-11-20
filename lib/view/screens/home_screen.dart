

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/screen_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ScreenWidget {
  static const String routeName = "home";

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logScreenView("HomeScreen");
    final router = AutoRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            router.push(const LoginScreenRoute());
          }, icon: const Icon(Icons.logout,), tooltip: "Sign Out",),
        ],
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(
        children: [
          const Text("For Students", style: TextStyle(fontStyle: FontStyle.italic)),
          openChartEditor(context),
          staticExercises(context),
          dynamicExercises(context),
          joinExercise(context),
          const Divider(),
          const Text("For Educators", style: TextStyle(fontStyle: FontStyle.italic)),
          manageProgram(context),
          const Divider(),
          const Text("Under Construction", style: TextStyle(fontStyle: FontStyle.italic)),
          openFollowUpForm(context),
          // TODO: re-enable once the reporting user is set up
          //reportIssue(context),
        ],
      ))),
    );
  }

  Widget manageProgram(BuildContext context) {
    return ButtonWidget(
      title: "Manage Program",
      onPressed: () {
        AutoRouter.of(context).push(ListProgramsScreenRoute());
      },
      backgroundColor: Colors.pinkAccent,
    );
  }

  Widget staticExercises(BuildContext context) {
    return ButtonWidget(
      title: "Static Exercises",
      onPressed: () {
        AutoRouter.of(context).push(StaticExerciseListScreenRoute());
      },
    );
  }

  Widget dynamicExercises(BuildContext context) {
    return ButtonWidget(
      title: "Dynamic Exercises",
      onPressed: () {
        AutoRouter.of(context).push(DynamicExerciseListScreenRoute());
      },
    );
  }

  Widget joinExercise(BuildContext context) {
    return ButtonWidget(
      title: "Join Group Exercise",
      onPressed: () {
        showDialog(context: context, builder: (context)  {
          var formKey = GlobalKey<FormState>();
          saveForm() {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
            }
          }
          return AlertDialog(
            title: const Text("Enter Exercise ID"),
            content: Form(
              key: formKey,
              child: TextFormField(
                validator: (value) {
                  return "Exercise not found";
                },
                onFieldSubmitted: (value) => saveForm(),
                onSaved: (value) {
                  // TODO: trigger exercise
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => saveForm(),
                child: const Text("Submit"),
              ),
            ],
          );
        });
      },
    );
  }

  Widget openChartEditor(BuildContext context) {
    return ButtonWidget(
      title: "Chart Editor",
      onPressed: () {
        AutoRouter.of(context).push(const ChartEditorPageRoute());
      },
    );
  }

  Widget openFollowUpForm(BuildContext context) {
    return ButtonWidget(
      title: "FupFormScreen",
      onPressed: () {
        AutoRouter.of(context).push(FupFormScreenRoute());
      },
      backgroundColor: Colors.grey,
    );
  }

  Widget reportIssue(BuildContext context) {
    return ButtonWidget(
      title: "Report Issue",
      backgroundColor: Colors.pinkAccent,
      onPressed: () async {
        if (!await launchUrl(_newGithubIssueURL)) {
          throw Exception("Could not launch URL: $_newGithubIssueURL");
        }
      },
    );
  }
}

final Uri _newGithubIssueURL = Uri.parse('https://github.com/BloomCycleCare/FollowMcFollowUp/issues/new');

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const ButtonWidget({super.key, required this.title, required this.onPressed, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        child: Padding(padding: const EdgeInsets.all(10), child: Text(
          title, style: const TextStyle(fontSize: 18))),
      ),
    );
  }
}