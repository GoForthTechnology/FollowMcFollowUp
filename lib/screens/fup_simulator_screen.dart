
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/utils/files.dart';
import 'package:fmfu/widgets/chart_widget.dart';
import 'package:fmfu/widgets/fup_form_widget.dart';
import 'package:fmfu/view_model/fup_simulator_view_model.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';

class FollowUpSimulatorPage extends StatefulWidget {
  final ExerciseState exerciseState;
  final String exerciseName;

  const FollowUpSimulatorPage({super.key, required this.exerciseState, required this.exerciseName});

  @override
  State<StatefulWidget> createState() => _FollowUpSimulatorPageState();
}

typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _FollowUpSimulatorPageState extends State<FollowUpSimulatorPage> with GlobalLoggy {

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logEvent(name: "Chart Correction Exercise - Start", parameters: {
      "exerciseName": widget.exerciseName,
    });
    final model = Provider.of<FollowUpSimulatorViewModel>(context, listen: false);
    model.restoreStateFromJson(widget.exerciseState, notify: false);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<FollowUpSimulatorViewModel>(builder: (context, model, child)  {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Follow Up Simulator"),
          actions: [
            IconButton(icon: Icon(model.showErrors ? Icons.visibility_off: Icons.visibility), onPressed: () {
              model.toggleShowErrors();
            },),
            IconButton(icon: const Icon(Icons.save), onPressed: () async {
              downloadJson(model.getStateAsJson(), "exercise.json");
            },),
            IconButton(icon: const Icon(Icons.open_in_browser), onPressed: () async {
              openJsonFile().then((file) async {
                if (file == null) {
                  _showSnackBar("No file selected");
                }
                final contents = await file!.readAsString();
                model.restoreStateFromJson(
                    ExerciseState.fromJson(jsonDecode(contents)));
                _showSnackBar("Loaded ${file.name}");
              }, onError: (error) => _showSnackBar(error.toString()));
            },),
          ],
        ),
        // TODO: figure out how to make horizontal scrolling work...
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Center(child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Padding(padding: const EdgeInsets.all(20), child: _chartWidget(model)),
                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Page10()),
              ])),
            )),
          ]),
        ),
      );
    });
  }

  void _showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ChartWidget _chartWidget(FollowUpSimulatorViewModel model) {
    return  ChartWidget(
      model: model,
      correctingEnabled: true,
      showErrors: model.showErrors,
      titleWidget: _chartTitleWidget(model),
      chart: model.charts[model.chartIndex],
      rightWidgetFn: (cycle) => null,
    );
  }

  Widget _chartTitleWidget(FollowUpSimulatorViewModel model) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(
      children: [
        if (model.showErrors) const Padding(padding: EdgeInsets.only(left: 10), child: Text("All charting errors (if any) are now highlighted in pink.", style: TextStyle(fontStyle: FontStyle.italic))),
        if (model.followUps().isNotEmpty) ...[
          Padding(padding: const EdgeInsets.only(left: 20), child: Text(
            "Current Follow Up: #${model.currentFollowUpNumber()}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
          Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: model.hasPreviousFollowUp() ? () {
                FirebaseAnalytics.instance.logEvent(name: "Goto previous followup");
                model.goToPreviousFollowup();
              } : null,
              child: const Text("Previous Followup"))),
          Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: model.hasNextFollowUp() ? () {
                FirebaseAnalytics.instance.logEvent(name: "Goto next followup");
                model.goToNextFollowup();
              } : null,
              child: const Text("Next Followup"))),
        ],
      ],
    ));
  }

  Widget titleButton(String title, VoidCallback onPressed) {
    return Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
      onPressed: onPressed, child: Text(title),
    ));
  }
}
