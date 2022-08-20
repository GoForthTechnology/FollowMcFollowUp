import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/instructions.dart';

typedef Cycles = List<List<RenderedObservation>>;

class CycleViewModel with ChangeNotifier {
  Cycles cycles = getCycles(CycleRecipe.standardRecipe, 10, false, false, false);

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

  static Cycles getCycles(CycleRecipe  recipe, int numCycles, bool askESQ, bool prePeakYellowStamps, bool postPeakYellowStamps) {
    List<Instruction> instructions = [];
    if (prePeakYellowStamps) {
      instructions.add(Instruction.k1);
    }
    if (postPeakYellowStamps) {
      instructions.add(Instruction.k2);
    }
    return List.generate(numCycles, (index) => renderObservations(recipe.getObservations(askESQ: askESQ), instructions));
  }
}