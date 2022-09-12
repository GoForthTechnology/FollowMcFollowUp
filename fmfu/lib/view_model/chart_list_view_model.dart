import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';

class ChartListViewModel with ChangeNotifier, UiLoggy {
  static final List<Instruction> _defaultInstructions = getActiveInstructions(false, false);

  List<Instruction> activeInstructions = _defaultInstructions;
  List<Chart> charts = getCharts(CycleRecipe.standardRecipe, 10, false, _defaultInstructions);
  bool showCycleControlBar = false;
  bool editEnabled = false;
  bool showErrors = false;
  int chartIndex = 0;

  void toggleControlBar() {
    showCycleControlBar = !showCycleControlBar;
    notifyListeners();
  }

  void toggleShowErrors() {
    showErrors = !showErrors;
    notifyListeners();
  }

  void toggleEdit() {
    editEnabled = !editEnabled;
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

  void updateCorrections(int cycleIndex, int entryIndex, StickerWithText? correction) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    if (correction == null) {
      cycle.corrections.remove(entryIndex);
    } else {
      cycle.corrections[entryIndex] = correction;
    }
    notifyListeners();
  }

  void setLengthOfPostPeakPhase(int cycleIndex, int? length) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    cycle.cycleStats = cycle.cycleStats.setLengthOfPostPeakPhase(length);
    notifyListeners();
  }

  void setMucusCycleScore(int cycleIndex, double? score) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    cycle.cycleStats = cycle.cycleStats.setMucusCycleScore(score);
    notifyListeners();
  }

  void editSticker(int cycleIndex, int entryIndex, StickerWithText? edit) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    var existingEntry = cycle.entries[entryIndex];
    cycle.entries[entryIndex] = ChartEntry(
      observationText: existingEntry.observationText,
      renderedObservation: existingEntry.renderedObservation,
      manualSticker: edit,
    );
    loggy.info("Altering sticker for cycle $cycleIndex @ $entryIndex");
    notifyListeners();
  }

  void editEntry(int cycleIndex, int entryIndex, String observationText) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    observationText = observationText.toUpperCase();
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
          //manualSticker: cycle.entries[i].manualSticker,
        ));
      }
      cycle.entries.clear();
      cycle.entries.addAll(newEntries);
      loggy.info("Re-rendering cycle $cycleIndex");
    } catch (e) {
      var existingEntry = cycle.entries[entryIndex];
      cycle.entries[entryIndex] = ChartEntry(
        observationText: observationText,
        renderedObservation: existingEntry.renderedObservation,
        //manualSticker: cycle.entries[entryIndex].manualSticker,
      );
      loggy.info("Adding invalid entry to cycle $cycleIndex @ $entryIndex");
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
              renderedObservation: observation,
      ))
          .toList(),
      {}));
    List<CycleSlice> slices = [];
    for (var cycle in cycles) {
      for (var offset in cycle.getOffsets()) {
        slices.add(CycleSlice(cycle, offset));
      }
    }
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
    if (batch.isNotEmpty) {
      while (batch.length < 6) {
        batch.add(CycleSlice(null, 0));
      }
      out.add(Chart(batch));
    }
    return out;
  }
}