import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';

class ChartListViewModel with ChangeNotifier {
  List<Chart> charts = getCharts(CycleRecipe.standardRecipe, 10, false, false, false);
  bool showCycleControlBar = false;
  int chartIndex = 0;

  void toggleControlBar() {
    showCycleControlBar = !showCycleControlBar;
    notifyListeners();
  }

  bool showNextButton() {
    return chartIndex < charts.length - 1;
  }

  bool showPreviousButton() {
    return chartIndex > 0;
  }

  void moveToNextChart() {
    if (!showNextButton()) {
      throw Exception("Cannot move to next!");
    }
    chartIndex++;
    notifyListeners();
  }

  void moveToPreviousChart() {
    if (!showPreviousButton()) {
      throw Exception("Cannot move to previous!");
    }
    chartIndex--;
    notifyListeners();
  }

  void updateCharts(
      CycleRecipe recipe, {
        int numCycles = 50,
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
      }) {
    charts = getCharts(recipe, numCycles, askESQ, prePeakYellowStamps, postPeakYellowStamps);
    notifyListeners();
  }

  static List<Chart> getCharts(CycleRecipe  recipe, int numCycles, bool askESQ, bool prePeakYellowStamps, bool postPeakYellowStamps) {
    List<Instruction> instructions = [];
    if (prePeakYellowStamps) {
      instructions.add(Instruction.k1);
    }
    if (postPeakYellowStamps) {
      instructions.add(Instruction.k2);
    }
    List<Cycle> cycles = List.generate(numCycles, (index) => Cycle(
        renderObservations(recipe.getObservations(askESQ: askESQ), instructions), {}));
    print("Generated ${cycles.length} cycles");
    List<Chart> out = [];
    List<Cycle> slice = [];
    for (int i=0; i<cycles.length; i++) {
      if (slice.length < 6) {
        slice.add(cycles[i]);
      } else {
        out.add(Chart(slice));
        slice = [];
      }
    }
    print("Batched ${out.length} complete charts");
    if (slice.isNotEmpty) {
      while (slice.length < 6) {
        slice.add(Cycle.empty());
      }
      out.add(Chart(slice));
    }
    print("Added partial charts");
    return out;
  }
}