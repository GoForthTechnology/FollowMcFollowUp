import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';

class ChartCorrectionViewModel extends ChangeNotifier {
  final Chart chart = getChart();
  int entryIndex = 0;
  bool showFullCycle = false;
  bool showSticker = true;

  void toggleShowFullCycle() {
    showFullCycle = !showFullCycle;
    notifyListeners();
  }

  void toggleShowSticker() {
    showSticker = !showSticker;
    notifyListeners();
  }

  void nextEntry() {
    entryIndex++;
    notifyListeners();
  }

  void previousEntry() {
    entryIndex--;
    notifyListeners();
  }

  bool showNextButton() {
    return entryIndex < chart.cycles[0].cycle!.entries.length - 1;
  }

  bool showPreviousButton() {
    return entryIndex > 0;
  }

  static Chart getChart() {
    var observations = CycleRecipe.create().getObservations();
    var entries = renderObservations(observations, []).map((ro) => ChartEntry.fromRenderedObservation(ro)).toList();
    return Chart([CycleSlice(Cycle(index: 0, entries: entries), 0)]);
  }
}