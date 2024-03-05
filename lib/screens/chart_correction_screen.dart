
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
    super.initState();
  }

  bool hasCorrectAnswer() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartCorrectionViewModel, ExerciseViewModel>(builder: (context, model, exerciseModel, child) {
      int entryIndex = min(
        model.cycles[0].entries.where((e) => e.manualSticker != null).length,
        model.cycles[0].entries.length - 1,
      );
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
                  editingEnabled: true,
                  correctingEnabled: false,
                  autoStamp: false,
                  soloCell: SoloCell(
                    cycleIndex: 0,
                    entryIndex: entryIndex,
                    showSticker: model.showSticker,
                  ),
                  rightWidgetFn: (cycle) => null,
                ),
              ],),
            ),
            Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(
              onPressed: model.toggleShowAnswers,
              child: model.showAnswers ? const Text("Hide Answers") : const Text("Show Answers"),
            )),
        ]))),
      );
    });
  }

  static const String checkMark = "\u2714";
  static const String crossMark = "\u2717";
  static const String questionMark = "\u003F";
}
