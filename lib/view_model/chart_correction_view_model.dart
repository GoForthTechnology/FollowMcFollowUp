import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_view_model.dart';

class ChartCorrectionViewModel extends ChartViewModel with ChangeNotifier {
  final _entryIndex = StreamController<int>.broadcast();

  int entryIndex = 0;
  bool showCycleControlBar = false;
  bool showFullCycle = false;
  bool showSticker = false;

  ChartCorrectionViewModel() : super(1) {
    toggleIncrementalMode();
    addCycle(CycleRecipe.create());
  }

  @override
  void onChartChange() {
    notifyListeners();
  }

  Stream<int> get entryIndexStream => _entryIndex.stream;

  void toggleControlBar() {
    showCycleControlBar = !showCycleControlBar;
    notifyListeners();
  }

  void toggleShowFullCycle() {
    showFullCycle = !showFullCycle;
    notifyListeners();
  }

  void toggleShowSticker() {
    showSticker = !showSticker;
    notifyListeners();
  }

  void nextEntry() {
    _entryIndex.add(entryIndex++);
    notifyListeners();
  }

  void previousEntry() {
    _entryIndex.add(entryIndex--);
    notifyListeners();
  }

  bool showNextButton() {
    var cycle = charts[0].cycles[0].cycle;
    return cycle != null && entryIndex < cycle.entries.length - 1;
  }

  bool showPreviousButton() {
    return entryIndex > 0;
  }
}
