import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/screen_widget.dart';
import 'package:fmfu/view/screens/home_screen.dart';

class LandingScreen extends ScreenWidget {
  LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logScreenView("LandingScreen");
    var formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("FCP Classroom"),
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("By clicking the button below, you acknowledge that you have permission to access this application."),
          ),
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(
              title: const Text("Password Authentication"),
              content: Form(
                key: formKey,
                child: TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value != "creighton") {
                      return "Incorrect password";
                    }
                    analytics.logLogin();
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, 'OK');
                      AutoRouter.of(context).push(HomeScreenRoute());
                    }
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, 'OK');
                      Navigator.of(context).pushNamed(HomeScreen.routeName);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ));
          }, child: const Text("Proceed"))
        ],
      ))),
    );
  }

}