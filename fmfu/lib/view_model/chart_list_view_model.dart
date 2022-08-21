import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/instructions.dart';

typedef Cycles = List<List<RenderedObservation>>;

class ChartListViewModel with ChangeNotifier {
  List<Cycles> cycles = getCycles(CycleRecipe.standardRecipe, 10, false, false, false);

  void updateCycles(
      CycleRecipe recipe, {
        int numCycles = 50,
        bool askESQ = false,
        bool prePeakYellowStamps = false,
        bool postPeakYellowStamps = false,
      }) {
    cycles = getCycles(recipe, numCycles, askESQ, prePeakYellowStamps, postPeakYellowStamps);
    notifyListeners();
  }

  static List<Cycles> getCycles(CycleRecipe  recipe, int numCycles, bool askESQ, bool prePeakYellowStamps, bool postPeakYellowStamps) {
    List<Instruction> instructions = [];
    if (prePeakYellowStamps) {
      instructions.add(Instruction.k1);
    }
    if (postPeakYellowStamps) {
      instructions.add(Instruction.k2);
    }
    Cycles cycles = List.generate(numCycles, (index) => renderObservations(recipe.getObservations(askESQ: askESQ), instructions));
    List<Cycles> out = [];
    Cycles slice = [];
    for (int i=0; i<cycles.length; i++) {
      if (slice.length < 6) {
        slice.add(cycles[i]);
      } else {
        out.add(List.of(slice));
        slice.clear;
      }
    }
    if (slice.isNotEmpty) {
      out.add(List.of(slice));
    }
    return out;
  }
}