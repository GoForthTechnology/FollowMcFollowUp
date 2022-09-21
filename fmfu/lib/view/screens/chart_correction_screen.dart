
import 'package:flutter/material.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:provider/provider.dart';

class ChartCorrectingScreen extends StatelessWidget {
  const ChartCorrectingScreen({Key? key}) : super(key: key);

  static const String routeName = "chartCorrection";

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartCorrectionViewModel>(builder: (context, model, child) => Scaffold(
      appBar: AppBar(
        title: const Text("Basic Chart Correcting"),
        actions: [
          IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {
            model.toggleControlBar();
          },),
        ],
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
        ChartWidget(
          chart: model.chart,
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
              onPressed: model.showPreviousButton() ? () => model.previousEntry() : null,
              child: const Text("Previous"),
            )),
            Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: model.showNextButton() ? () => model.nextEntry() : null,
              child: const Text("Next"),
            )),
            Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: () => model.toggleShowFullCycle(),
              child: Text(model.showFullCycle ? "Hide Full Cycle" : "Show Full Cycle"),
            )),
            Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: () => model.toggleShowSticker(),
              child: Text(model.showFullCycle ? "Hide Sticker" : "Show Sticker"),
            )),
          ])),
        ),
      ])
    )));
  }
}