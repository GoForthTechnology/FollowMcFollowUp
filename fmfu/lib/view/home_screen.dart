

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow McFollowUp"),
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(
        children: [
          ElevatedButton(onPressed: () {
            Navigator.of(context).pushNamed("charts");
          }, child: const Text("Chart Editor")),
        ],
      ))),
    );
  }

}