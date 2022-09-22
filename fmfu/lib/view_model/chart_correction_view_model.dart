import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_view_model.dart';

class ChartCorrectionViewModel extends ChartViewModel {
  int entryIndex = 0;
  bool showCycleControlBar = false;
  bool showFullCycle = false;
  bool showSticker = true;

  ChartCorrectionViewModel() : super(1) {
    toggleIncrementalMode();
    addCycle(CycleRecipe.create());
  }

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
    entryIndex++;
    notifyListeners();
  }

  void previousEntry() {
    entryIndex--;
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