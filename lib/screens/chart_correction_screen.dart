
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/widgets/chart_widget.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:fmfu/view_model/exercise_view_model.dart';
import 'package:provider/provider.dart';

class ChartCorrectingScreen extends StatefulWidget {
  final Cycle? cycle;

  const ChartCorrectingScreen({super.key, required this.cycle});

  @override
  State<StatefulWidget> createState() => ChartCorrectionState();
}

class ChartCorrectionState extends State<ChartCorrectingScreen> {

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(name: "Stamp Selection Exercise - Start");
    final model = Provider.of<ChartCorrectionViewModel>(context, listen: false);
    if (widget.cycle != null) {
      model.setCycle(widget.cycle!, notify: false);
    }
    final exerciseModel = Provider.of<ExerciseViewModel>(context, listen: false);
    exerciseModel.reset();
    super.initState();
  }

  bool hasCorrectAnswer() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartCorrectionViewModel, ExerciseViewModel>(builder: (context, model, exerciseModel, child) {
      var entries = model.cycles[0].entries;
      var numWithStamp = entries.where((e) => e.manualSticker != null).length;
      var exerciseComplete = numWithStamp == entries.length;
      var entryIndex = min(numWithStamp, entries.length - 1);
      return Scaffold(
        appBar: AppBar(
          title: const Text("Basic Chart Correcting"),
          actions: [
            if (widget.cycle == null) IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {
              model.toggleControlBar();
            },),
          ],
        ),
        body: Center(child: Padding(padding: const EdgeInsets.all(10), child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Day #${(entryIndex+1).toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(children: [
                ChartWidget(
                  chart: model.charts[0],
                  model: model,
                  includeFooter: false,
                  stampEditingEnabled: true,
                  observationEditingEnabled: false,
                  correctingEnabled: false,
                  autoStamp: false,
                  soloCell: SoloCell(
                    cycleIndex: 0,
                    entryIndex: entryIndex,
                    showSticker: model.showSticker,
                  ),
                  rightWidgetFn: (cycle) => null,
                  showErrors: model.showAnswers || exerciseComplete, // only show errors when answers are enabled
                ),
              ],),
            ),
            Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(
              onPressed: model.toggleShowAnswers,
              child: model.showAnswers ? const Text("Hide Answers") : const Text("Show Answers"),
            )),
            if (exerciseComplete) Text("Exercise complete", style: Theme.of(context).textTheme.displayMedium,),
            if (exerciseComplete) Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: const Text("Select Another Drill"))),
        ]))),
      );
    });
  }

  static const String checkMark = "\u2714";
  static const String crossMark = "\u2717";
  static const String questionMark = "\u003F";
}
