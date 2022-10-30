

import 'package:flutter/material.dart';
import 'package:fmfu/view/screens/chart_correction_screen.dart';
import 'package:fmfu/view/screens/chart_screen.dart';
import 'package:fmfu/view/screens/fupf_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
          openChartCorrecting(context),
          openChartEditor(context),
          openFollowUpForm(context),
          // TODO: re-enable once the reporting user is set up
          //reportIssue(context),
        ],
      ))),
    );
  }

  Widget openChartCorrecting(BuildContext context) {
    return ButtonWidget(
      title: "Chart Correcting",
      onPressed: () {
        Navigator.of(context).pushNamed(ChartCorrectingScreen.routeName);
      },
    );
  }

  Widget openChartEditor(BuildContext context) {
    return ButtonWidget(
      title: "Chart Editor",
      onPressed: () {
        Navigator.of(context).pushNamed(ChartPage.routeName);
      },
    );
  }

  Widget openFollowUpForm(BuildContext context) {
    return ButtonWidget(
      title: "FupFormScreen",
      onPressed: () {
        Navigator.of(context).pushNamed(FupFormScreen.routeName);
      },
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