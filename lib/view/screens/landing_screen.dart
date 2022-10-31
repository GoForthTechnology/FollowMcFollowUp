import 'package:flutter/material.dart';
import 'package:fmfu/view/screens/home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow McFollowUp"),
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
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, 'OK');
                      Navigator.of(context).pushNamed(HomeScreen.routeName);
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