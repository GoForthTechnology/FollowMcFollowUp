import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';

class ChartViewModel with ChangeNotifier, GlobalLoggy {
  static final List<Instruction> _defaultInstructions = _getActiveInstructions(false, false);

  final numCyclesPerChart;
  bool incrementalMode = false;
  List<Instruction> activeInstructions = _defaultInstructions;
  List<ErrorScenario> errorScenarios = [];
  List<Cycle> cycles = [];
  List<Chart> charts = [];

  ChartViewModel(this.numCyclesPerChart);

  void toggleIncrementalMode() {
    if (incrementalMode) {
      _initCharts();
    } else {
      cycles = [];
      charts = _getCharts(cycles);
    }
    incrementalMode = !incrementalMode;
    notifyListeners();
  }

  void updateCharts(
      CycleRecipe recipe, {
        int numCycles = 50,
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
        List<ErrorScenario> errorScenarios = const [],
      }) {
    if (incrementalMode) {
      return;
    }
    activeInstructions = _getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    cycles = _getCycles(recipe, numCycles, askESQ, activeInstructions, errorScenarios);
    charts = _getCharts(cycles);
    notifyListeners();
  }

  void swapLastCycle(
      CycleRecipe recipe, {
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
        List<ErrorScenario> errorScenarios = const [],
      }) {
    if (!incrementalMode) {
      loggy.error("swapLastCycle only supported in incremental mode!");
      return;
    }
    if (cycles.isEmpty) {
      loggy.error("no cycle to swap!");
      return;
    }
    activeInstructions = _getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    int lastIndex = cycles.length - 1;
    cycles[lastIndex] = _getCycles(recipe, 1, askESQ, activeInstructions, errorScenarios)[0];
    charts = _getCharts(cycles);
    notifyListeners();
  }

  void addCycle(
      CycleRecipe recipe, {
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
        List<ErrorScenario> errorScenarios = const [],
      }) {
    if (!incrementalMode) {
      loggy.error("addCycle only supported in incremental mode!");
      return;
    }
    activeInstructions = _getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    cycles.addAll(_getCycles(recipe, 1, askESQ, activeInstructions, errorScenarios));
    charts = _getCharts(cycles);
    notifyListeners();
  }

  void updateErrors(List<ErrorScenario> errorScenarios) {
    List<Cycle> updatedCycles = [];
    for (var cycle in cycles) {
      updatedCycles.add(Cycle(
        index: cycle.index,
        observationCorrections: cycle.observationCorrections,
        stickerCorrections: cycle.stickerCorrections,
        entries: introduceErrors(cycle.entries, errorScenarios),
      ));
    }
    cycles = updatedCycles;
    charts = _getCharts(cycles);
    this.errorScenarios = errorScenarios;
    notifyListeners();
  }

  void updateStickerCorrections(int cycleIndex, int entryIndex, StickerWithText? correction) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    if (correction == null) {
      cycle.stickerCorrections.remove(entryIndex);
    } else {
      cycle.stickerCorrections[entryIndex] = correction;
    }
    notifyListeners();
  }

  void updateObservationCorrections(int cycleIndex, int entryIndex, String? correction) {
    var cycle = _findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    if (correction == null) {
      cycle.observationCorrections.remove(entryIndex);
    } else {
      cycle.observationCorrections[entryIndex] = correction;
    }
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

  static List<Instruction> _getActiveInstructions(bool prePeakYellowStamps, bool postPeakYellowStamps) {
    List<Instruction> instructions = [];
    if (prePeakYellowStamps) {
      instructions.add(Instruction.k1);
    }
    if (postPeakYellowStamps) {
      instructions.add(Instruction.k2);
    }
    return instructions;
  }

  static List<Cycle> _getCycles(
      CycleRecipe  recipe,
      int numCycles,
      bool askESQ,
      List<Instruction> instructions,
      List<ErrorScenario> errorScenarios) {
    return List.generate(numCycles, (index) => Cycle(
      index: index,
      entries: introduceErrors(renderObservations(recipe.getObservations(askESQ: askESQ), instructions)
          .map((observation) => ChartEntry(
        observationText: observation.observationText,
        renderedObservation: observation,
      ))
          .toList(), errorScenarios),
      stickerCorrections: {},
      observationCorrections: {},
    ));
  }

  List<Chart> _getCharts(List<Cycle> cycles) {
    List<CycleSlice> slices = [];
    for (var cycle in cycles) {
      for (var offset in cycle.getOffsets()) {
        slices.add(CycleSlice(cycle, offset));
      }
    }
    List<Chart> out = [];
    List<CycleSlice> batch = [];
    for (var slice in slices) {
      if (batch.length < numCyclesPerChart) {
        batch.add(slice);
      } else {
        out.add(Chart(batch));
        batch = [slice];
      }
    }
    if (out.isEmpty || batch.isNotEmpty) {
      while (batch.length < numCyclesPerChart) {
        batch.add(CycleSlice(null, 0));
      }
      out.add(Chart(batch));
    }
    return out;
  }

  void _initCharts() {
    cycles = _getCycles(CycleRecipe.create(), 10, false, _defaultInstructions, []);
    charts = _getCharts(cycles);
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
}