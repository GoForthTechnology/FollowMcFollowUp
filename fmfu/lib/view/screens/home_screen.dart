

import 'package:flutter/material.dart';
import 'package:fmfu/view/screens/chart_screen.dart';
import 'package:fmfu/view/screens/fupf_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow McFollowUp"),
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(
        children: [
          _button(context, "Chart Editor", ChartPage.routeName),
          _button(context, "FUP Form", FupFormScreen.routeName),
        ],
      ))),
    );
  }

  Widget _button(BuildContext context, String buttonTilte, String route) {
    return Container(margin: const EdgeInsets.all(10), child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Padding(padding: const EdgeInsets.all(10), child: Text(
            buttonTilte, style: const TextStyle(fontSize: 18))),
    ));
  }

}