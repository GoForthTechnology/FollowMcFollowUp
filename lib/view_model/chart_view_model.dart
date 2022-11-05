import 'dart:convert';

import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';
import 'package:time_machine/time_machine.dart';

abstract class ChartViewModel with GlobalLoggy {
  static final List<Instruction> _defaultInstructions = _getActiveInstructions(false, false);
  static final LocalDate _startDate = LocalDate(DateTime.now().year, 1, 1);

  final int numCyclesPerChart;
  bool incrementalMode = false;
  List<Instruction> activeInstructions = _defaultInstructions;
  Set<ErrorScenario> errorScenarios = {};
  CycleRecipe? recipe;
  List<Cycle> cycles = [];
  List<Chart> charts = [];

  bool hasStickerEdits = false;
  bool hasObservationEdits = false;

  bool autoAdvanceToLastFollowup = false;
  final List<LocalDate> _followUps = [];
  LocalDate? _currentFollowup;
  LocalDate _startOfCharting = _startDate;

  ChartViewModel(this.numCyclesPerChart);

  void onChartChange();

  String getStateAsJson() {
    return jsonEncode(ExerciseState.fromChartViewModel(this).toJson());
  }

  List<String> dynamicExerciseIssues() {
    List<String> issues = [];
    if (recipe == null) {
      issues.add("Chart not based on a (single) recipe");
    }
    if (hasObservationEdits) {
      issues.add("Observation edits would be lost");
    }
    if (hasStickerEdits) {
      issues.add("Stamp edits would be lost");
    }
    return issues;
  }

  void restoreStateFromJson(ExerciseState state, {notify = true}) {
    activeInstructions = state.activeInstructions;
    errorScenarios = state.errorScenarios;
    cycles = state.cycles;
    charts = getCharts(cycles, numCyclesPerChart);
    _startOfCharting = state.startOfCharting;
    _followUps.clear();
    _followUps.addAll(state.followUps);
    if (_followUps.isNotEmpty) {
      _currentFollowup = _followUps[0];
    }
    if (notify) {
      onChartChange();
    }
  }

  void setStartOfCharting(LocalDate date) {
    if (date < earliestStartOfCharting()) {
      throw Exception("$date before earliest start of charting ${earliestStartOfCharting()}");
    }
    if (date > latestStartOfCharting()) {
      throw Exception("$date after latest start of charting ${latestStartOfCharting()}");
    }
    _startOfCharting = date;
    onChartChange();
  }

  LocalDate startOfCharting() {
    return _startOfCharting;
  }

  LocalDate earliestStartOfCharting() {
    return _startDate;
  }

  LocalDate latestStartOfCharting() {
    int numDays = 0;
    for (var cycle in cycles) {
      numDays += cycle.entries.length;
    }
    return _startDate.addDays(numDays);
  }

  int? currentFollowUpNumber() {
    if (_currentFollowup == null) {
      return null;
    }
    return _followUps.indexOf(_currentFollowup!) + 1;
  }

  LocalDate? currentFollowUpDate() {
    if (_currentFollowup == null) {
      return null;
    }
    return _currentFollowup;
  }

  LocalDate nextFollowUpDate() {
    if (_followUps.isEmpty) {
      return _startOfCharting.addDays(14);
    }
    if (_followUps.length < 4) {
      return _followUps.last.addDays(14);
    }
    if (_followUps.length == 4) {
      return _followUps.last.addDays(28);
    }
    return _followUps.last.addDays(3 * 28);
  }

  bool hasNextFollowUp() {
    if (_followUps.isEmpty || _currentFollowup == null) {
      if (_currentFollowup == null) {
        loggy.warning("Current followup should not be null...");
      }
      return false;
    }
    return _followUps.indexOf(_currentFollowup!) < _followUps.length - 1;
  }

  void goToNextFollowup() {
    if (!hasNextFollowUp()) {
      loggy.warning("Trying to go to next followup without checking if one exists!");
      return;
    }
    var currentIndex = _followUps.indexOf(_currentFollowup!);
    _currentFollowup = _followUps[currentIndex + 1];
    onChartChange();
  }

  void goToPreviousFollowup() {
    if (!hasPreviousFollowUp()) {
      loggy.warning("Trying to go to previous followup without checking if one exists!");
      return;
    }
    var currentIndex = _followUps.indexOf(_currentFollowup!);
    _currentFollowup = _followUps[currentIndex - 1];
    onChartChange();
  }

  bool hasPreviousFollowUp() {
    if (_followUps.isEmpty || _currentFollowup == null) {
      if (_currentFollowup == null) {
        loggy.warning("Current followup should not be null...");
      }
      return false;
    }
    return _followUps.indexOf(_currentFollowup!) > 0;
  }

  bool hasFollowUp(LocalDate date) {
    return _followUps.contains(date);
  }

  void addFollowUp(LocalDate date) {
    if (date > latestStartOfCharting()) {
      throw Exception("$date is after latest start of charting ${latestStartOfCharting()}");
    }
    if (date < earliestStartOfCharting()) {
      throw Exception("$date is before earliest start of charting ${earliestStartOfCharting()}");
    }
    if (_followUps.contains(date)) {
      throw Exception("Duplicate follow up date $date");
    }
    _followUps.add(date);
    _followUps.sort();
    if (autoAdvanceToLastFollowup) {
      _currentFollowup = date;
    } else {
      _currentFollowup ??= date;
    }
    onChartChange();
  }

  void removeFollowUp(LocalDate date) {
    if (_currentFollowup == date) {
      _currentFollowup = null;
    }
    _followUps.remove(date);
    onChartChange();
  }

  List<LocalDate> followUps() {
    return List.from(_followUps);
  }

  void toggleIncrementalMode() {
    if (incrementalMode) {
      _initCharts();
    } else {
      cycles = [];
      charts = getCharts(cycles, numCyclesPerChart);
    }
    incrementalMode = !incrementalMode;
    onChartChange();
  }

  void updateCharts(
      CycleRecipe recipe, {
        int numCycles = 50,
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
        Set<ErrorScenario> errorScenarios = const {},
      }) {
    if (incrementalMode) {
      return;
    }
    activeInstructions = _getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    this.recipe = recipe;
    cycles = _getCycles(recipe, numCycles, askESQ, activeInstructions, errorScenarios);
    charts = getCharts(cycles, numCyclesPerChart);
    onChartChange();
  }

  void swapLastCycle(
      CycleRecipe recipe, {
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
        Set<ErrorScenario> errorScenarios = const {},
      }) {
    if (!incrementalMode) {
      loggy.error("swapLastCycle only supported in incremental mode!");
      return;
    }
    if (cycles.isEmpty) {
      loggy.error("no cycle to swap!");
      return;
    }
    this.recipe = null;
    activeInstructions = _getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    int lastIndex = cycles.length - 1;
    cycles[lastIndex] = _getCycles(recipe, 1, askESQ, activeInstructions, errorScenarios)[0];
    charts = getCharts(cycles, numCyclesPerChart);
    onChartChange();
  }

  void setCycle(Cycle cycle) {
    cycles = [cycle];
    charts = getCharts(cycles, numCyclesPerChart);
    onChartChange();
  }

  void addCycle(
      CycleRecipe recipe, {
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
        Set<ErrorScenario> errorScenarios = const {},
      }) {
    if (!incrementalMode) {
      loggy.error("addCycle only supported in incremental mode!");
      return;
    }
    this.recipe = null;
    activeInstructions = _getActiveInstructions(prePeakYellowStamps, postPeakYellowStamps);
    cycles.addAll(_getCycles(recipe, 1, askESQ, activeInstructions, errorScenarios));
    charts = getCharts(cycles, numCyclesPerChart);
    onChartChange();
  }

  void updateErrors(Set<ErrorScenario> errorScenarios) {
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
    charts = getCharts(cycles, numCyclesPerChart);
    this.errorScenarios = errorScenarios;
    onChartChange();
  }

  void updateStickerCorrections(int cycleIndex, int entryIndex, StickerWithText? correction) {
    var cycle = findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    if (correction == null) {
      cycle.stickerCorrections.remove(entryIndex);
    } else {
      cycle.stickerCorrections[entryIndex] = correction;
    }
    onChartChange();
  }

  void updateObservationCorrections(int cycleIndex, int entryIndex, String? correction) {
    var cycle = findCycle(cycleIndex);
    if (cycle == null) {
      throw Exception("Could not find cycle at index $cycleIndex");
    }
    if (correction == null) {
      cycle.observationCorrections.remove(entryIndex);
    } else {
      cycle.observationCorrections[entryIndex] = correction;
    }
    onChartChange();
  }

  void editSticker(int cycleIndex, int entryIndex, StickerWithText? edit) {
    var cycle = findCycle(cycleIndex);
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
    hasStickerEdits = true;
    onChartChange();
  }

  void editEntry(int cycleIndex, int entryIndex, String observationText) {
    var cycle = findCycle(cycleIndex);
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
    hasObservationEdits = true;
    onChartChange();
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
      Set<ErrorScenario> errorScenarios) {
    List<Cycle> cycles = [];
    LocalDate currentDate = _startDate;
    for (int i=0; i<numCycles; i++) {
      var observations = recipe.getObservations(askESQ: askESQ);
      var renderedObservations = renderObservations(observations, instructions, startDate: currentDate);
      currentDate = currentDate.addDays(renderedObservations.length);
      var chartEntries = renderedObservations.map((o) => ChartEntry(
          observationText: o.observationText,
          renderedObservation: o,
      )).toList();
      chartEntries = introduceErrors(chartEntries, errorScenarios);
      cycles.add(Cycle(
        index: i,
        entries: chartEntries,
        stickerCorrections: {},
        observationCorrections: {},
      ));
    }
    return cycles;
  }

  static List<Chart> getCharts(List<Cycle> cycles, int numCyclesPerChart) {
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
    cycles = _getCycles(CycleRecipe.create(), 10, false, _defaultInstructions, {});
    charts = getCharts(cycles, numCyclesPerChart);
  }

  Cycle? findCycle(int cycleIndex) {
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
