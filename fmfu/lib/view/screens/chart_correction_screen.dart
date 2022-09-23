
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/chart_row_widget.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/control_bar_widget.dart';
import 'package:fmfu/view/widgets/correction_exercise_bar.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:fmfu/view_model/exercise_view_model.dart';
import 'package:provider/provider.dart';

class ChartCorrectingScreen extends StatelessWidget {
  const ChartCorrectingScreen({Key? key}) : super(key: key);

  static const String routeName = "chartCorrection";

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartCorrectionViewModel, ExerciseViewModel>(builder: (context, model, exerciseModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Basic Chart Correcting"),
            actions: [
              IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {
                model.toggleControlBar();
              },),
            ],
          ),
          body: Padding(padding: const EdgeInsets.all(10), child: SingleChildScrollView(child: Row(children: [
            const Spacer(),
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
              if (model.showCycleControlBar) ControlBarWidget(model: model),
              ChartWidget(
                chart: model.charts[0],
                includeFooter: false,
                soloCell: model.showFullCycle ? null : SoloCell(
                  cycleIndex: 0,
                  entryIndex: model.entryIndex,
                  showSticker: model.showSticker,
                ),
                titleWidget: Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
                  Text(
                    "Correcting Day #${(model.entryIndex+1).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
                    onPressed: model.showPreviousButton() ? () {
                      model.previousEntry();
                    }: null,
                    child: const Text("Previous"),
                  )),
                  Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
                    onPressed: model.showNextButton() ? () {
                      exerciseModel.clearSelection();
                      model.nextEntry();
                    } : null,
                    child: const Text("Next"),
                  )),
                  Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
                    onPressed: () => model.toggleShowFullCycle(),
                    child: Text(model.showFullCycle ? "Hide Full Cycle" : "Show Full Cycle"),
                  )),
                  Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
                    onPressed: () => model.toggleShowSticker(),
                    child: Text(model.showSticker ? "Hide Sticker" : "Show Sticker"),
                  )),
                ])),
              ),
              ChartRowWidget(
                dayOffset: 0,
                topCellCreator: (entryIndex) => exerciseModel.hasAnswer(entryIndex) && (model.showFullCycle || entryIndex == model.entryIndex)
                    ? StickerWidget(stickerWithText: exerciseModel.answerSubmissions[entryIndex], onTap: () {})
                    : ChartCellWidget(content: Container(), backgroundColor: Colors.white, onTap: () {}),
                bottomCellCreator: (entryIndex) => ChartCellWidget(
                  content: Text(
                    exerciseModel.hasAnswer(entryIndex) ? "Answer\nSubmitted" : "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 8),
                  ),
                  backgroundColor: Colors.white,
                  onTap: () {},
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10), child: CorrectionExerciseBar()),
            ]),
            const Spacer(),
          ]
          ))));
    });
  }
}