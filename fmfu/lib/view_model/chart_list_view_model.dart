import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';

class ChartListViewModel with ChangeNotifier {
  static final List<Instruction> _defaultInstructions = getActiveInstructions(false, false);

  List<Instruction> activeInstructions = _defaultInstructions;
  List<Chart> charts = getCharts(CycleRecipe.standardRecipe, 10, false, _defaultInstructions);
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
    activeInstructions = getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    charts = getCharts(recipe, numCycles, askESQ, activeInstructions);
    notifyListeners();
  }

  void editEntry(int cycleIndex, int entryIndex, String observationText) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    try {
      var inputs = cycle.entries.map((e) => e.observationText).toList();
      inputs[entryIndex] = observationText;
      var observations = inputs.map((input) => parseObservation(input)).toList();
      var renderedObservations = renderObservations(observations, activeInstructions);
      List<ChartEntry> newEntries = [];
      for (int i=0; i<renderedObservations.length; i++) {
        newEntries.add(ChartEntry(
          observationText: inputs[i],
          renderedObservation: renderedObservations[i],
        ));
      }
      cycle.entries.clear();
      cycle.entries.addAll(newEntries);
      print("Re-rendering cycle $cycleIndex");
    } catch (e) {
      var existingEntry = cycle.entries[entryIndex];
      cycle.entries[entryIndex] = ChartEntry(
        observationText: observationText,
        renderedObservation: existingEntry.renderedObservation,
      );
      print("Adding invalid entry to cycle $cycleIndex @ $entryIndex");
    }
    notifyListeners();
  }

  Cycle? _findCycle(int cycleIndex) {
    for (var chart in charts) {
      for (var cycle in chart.cycles) {
        if (cycle.cycle?.index == cycleIndex) {
          return cycle.cycle;
        }
      }
    }
    return null;
  }

  static List<Instruction> getActiveInstructions(bool prePeakYellowStamps, bool postPeakYellowStamps) {
    List<Instruction> instructions = [];
    if (prePeakYellowStamps) {
      instructions.add(Instruction.k1);
    }
    if (postPeakYellowStamps) {
      instructions.add(Instruction.k2);
    }
    return instructions;
  }

  static List<Chart> getCharts(CycleRecipe  recipe, int numCycles, bool askESQ, List<Instruction> instructions) {
    List<Cycle> cycles = List.generate(numCycles, (index) => Cycle(
      index,
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