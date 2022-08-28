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
        renderObservations(recipe.getObservations(askESQ: askESQ), instructions)
            .map((observation) => ChartEntry(
                observationText: observation.observationText,
                renderedObservation: observation))
            .toList(),
        {}));
    print("Generated ${cycles.length} cycles");
    List<CycleSlice> slices = [];
    for (var cycle in cycles) {
      for (var offset in cycle.getOffsets()) {
        slices.add(CycleSlice(cycle, offset));
      }
    }
    print("Generated ${slices.length} slices");
    List<Chart> out = [];
    List<CycleSlice> batch = [];
    for (var slice in slices) {
      if (batch.length < 6) {
        batch.add(slice);
      } else {
        out.add(Chart(batch));
        batch = [];
      }
    }
    print("Batched ${out.length} complete charts");
    if (batch.isNotEmpty) {
      while (batch.length < 6) {
        batch.add(CycleSlice(null, 0));
      }
      out.add(Chart(batch));
    }
    print("Added partial charts");
    return out;
  }
}