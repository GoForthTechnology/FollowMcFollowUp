
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/chart_row_widget.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/correction_exercise_bar.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';
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
              "Day #${(model.entryIndex+1).toString().padLeft(2, '0')}",
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
                  soloCell: model.showFullCycle ? null : SoloCell(
                    cycleIndex: 0,
                    entryIndex: model.entryIndex,
                    showSticker: model.showSticker,
                  ),
                  rightWidgetFn: (cycle) => null,
                ),
                ChartRowWidget(
                  dayOffset: 0,
                  topCellCreator: (entryIndex) => exerciseModel.hasAnswer(entryIndex) && (model.showFullCycle || entryIndex <= model.entryIndex)
                      ? StickerWidget(stickerWithText: exerciseModel.stampAnswerSubmissions[entryIndex], onTap: () {})
                      : ChartCellWidget(content: Container(), backgroundColor: Colors.white, onTap: () {}),
                  bottomCellCreator: (entryIndex) => ChartCellWidget(
                    content: Text(_getText(exerciseModel, entryIndex), textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
                    backgroundColor: Colors.white,
                    onTap: () {},
                  ),
                ),
              ],),
            ),
            Padding(padding: const EdgeInsets.only(top: 10), child: _getQuestionWidget(exerciseModel)),
        ]))),
      );
    });
  }

  String _getText(ExerciseViewModel model, int entryIndex) {
    if (model.entryIndex() == entryIndex) {
      return questionMark;
    }
    if (!model.hasAnswer(entryIndex)) {
      return "";
    }
    if (model.hasCorrectStamp(entryIndex, widget.cycle!.entries[entryIndex])) {
      return checkMark;
    }
    return crossMark;
  }

  Widget _getQuestionWidget(ExerciseViewModel model) {
    switch (model.getQuestion()) {
      case Question.sticker:
        return const StampSelectionWidget();
      case Question.text:
        var sticker = model.stampAnswerSubmissions[model.entryIndex()]?.sticker ?? Sticker.white;
        return TextSelectionWidget(sticker: sticker,);
    }
  }

  static const String checkMark = "\u2714";
  static const String crossMark = "\u2717";
  static const String questionMark = "\u003F";
}
