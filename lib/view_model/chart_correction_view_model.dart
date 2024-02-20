import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_view_model.dart';

class ChartCorrectionViewModel extends ChartViewModel with ChangeNotifier {
  final _entryIndex = StreamController<int>.broadcast();

  int entryIndex = 0;
  bool showCycleControlBar = false;
  bool showAnswers = false;
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

  void nextEntry() {
    _entryIndex.add(entryIndex++);
    notifyListeners();
  }

  bool showNextButton() {
    var cycle = findCycle(1);
    return cycle != null && entryIndex < cycle.entries.length - 1;
  }

  void toggleShowAnswers() {
    showAnswers = !showAnswers;
    cycles.first.entries.forEachIndexed((index, entry) {
      if (showAnswers) {
        var correctSticker = entry.renderedObservation!.getStickerWithText();
        if (entry.manualSticker != null && entry.manualSticker != correctSticker) {
          updateStickerCorrections(1, index, correctSticker);
        }
      } else {
        updateStickerCorrections(1, index, null);
      }
    });
    notifyListeners();
  }
}
