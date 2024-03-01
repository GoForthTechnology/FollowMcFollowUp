import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/student_profile.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

class AddStudentDialog extends StatefulWidget {

  const AddStudentDialog({super.key});

  @override
  State<StatefulWidget> createState() => AddStudentDialogState();
}

class AddStudentDialogState extends State<AddStudentDialog> with GlobalLoggy {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final studentNumberController = TextEditingController();
  final emailController = TextEditingController();

  StudentProfile studentProfile(String id) {
    return StudentProfile(
      id: id,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      emailAddress: emailController.text,
    );
  }

  void save() async {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    var router = AutoRouter.of(context);
    if (formKey.currentState!.validate()) {
      var userService = Provider.of<UserService>(context, listen: false);
      var educatorProfile = await userService.currentEducator().first;

      var email = emailController.text;
      var password = "${educatorProfile.firstName.toLowerCase()}${educatorProfile.lastName.toLowerCase()}";

      loggy.debug("Creating user for educator: $educatorProfile, student: $email");

      var auth = FirebaseAuth.instance;
      try {
        var creds = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        var newUser = creds.user;
        if (newUser == null) {
          throw Exception();
        }
        await auth.sendPasswordResetEmail(email: email);
        await userService.createStudent(studentProfile(newUser.uid));
        close();
      } on FirebaseAuthException catch (e) {
        router.pop();
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void close() {
    AutoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 400, height: 300), child: AlertDialog(
        title: const Text("Add a Student"),
        actions: [
          TextButton(onPressed: () => AutoRouter.of(context).pop(), child: const Text("Cancel")),
          TextButton(onPressed: save, child: const Text("Submit")),
        ],
        content: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(labelText: "First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Value required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: "Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Value required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email Address"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Value required";
              }
              return null;
            },
          ),
        ]))),
    );
  }
}
