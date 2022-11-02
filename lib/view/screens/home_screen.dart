

import 'package:auto_route/auto_route.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow McFollowUp"),
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(
        children: [
          openChartEditor(context),
          openFollowUpForm(context),
          // TODO: re-enable once the reporting user is set up
          //reportIssue(context),
        ],
      ))),
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