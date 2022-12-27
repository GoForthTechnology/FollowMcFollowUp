

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/user_profile.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/screen_widget.dart';
import 'package:fmfu/view/screens/chart_editor_screen.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

class HomeScreen extends ScreenWidget with UiLoggy {
  static const String routeName = "home";

  HomeScreen({Key? key}) : super(key: key);

  Widget _tile({
    required Color color,
    required String title,
    required IconData icon,
    required String text,
    required Function() onClick,
  }) {
    return GestureDetector(onTap: onClick, child: Container(
      padding: const EdgeInsets.all(8),
      color: color,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        const Spacer(),
        Icon(icon, size: 50,),
        const Spacer(),
        Text(text),
      ]),
    ));
  }

  void _comingSoonSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text("Coming Soon!"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget content(BuildContext context, UserProfile? userProfile) {
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
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 400), child: GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 300.0,
        children: <Widget>[
          _tile(
            color: Colors.lightBlue,
            icon: Icons.person,
            title: "Exercises",
            text: "Get some extra practice.",
            onClick: () => router.push(const ExerciseScreenRoute()),
          ),
          _tile(
            color: Colors.lightBlue,
            icon: Icons.group,
            title: "Group Exercise",
            text: "Join a group exercise.",
            onClick: () {
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
                        _comingSoonSnackBar(context);
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
          ),
          _tile(
              color: Colors.lightBlue,
              icon: Icons.edit,
              title: "Exercise Builder",
              text: "Create an exercise.",
              onClick: () async {
                ChartEditorPage.route(context).then((route) => router.push(route));
              }
          ),
          _tile(
            color: Colors.lightBlue,
            icon: Icons.assignment,
            title: "Assignments",
            text: "Complete your pre-client assignments",
            onClick: () => router.push(const AssignmentListScreenRoute()),
          ),
          if (userProfile?.isAnEducator() ?? false) _tile(
            color: Colors.grey[300]!,
            icon: Icons.engineering,
            //icon: Icons.edit_calendar,
            title: "Manage Program",
            text: "Under construction.",
            onClick: () => _comingSoonSnackBar(context),
          ),
          _tile(
            color: Colors.grey[300]!,
            icon: Icons.engineering,
            title: "Follow Up Form",
            text: "Under construction.",
            onClick: () => router.push(FupFormScreenRoute()),
          ),
        ],
      ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    logScreenView("HomeScreen");
    return Consumer<UserService>(builder: (context, userService, _) => FutureProvider<UserProfile?>(
      create: (_) => userService.getOrCreateProfile(),
      initialData: null,
      child: Consumer<UserProfile?>(builder: (context, userProfile, _) => content(context, userProfile)),
    ));
  }
}
