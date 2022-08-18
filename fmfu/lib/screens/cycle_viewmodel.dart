import 'package:flutter/material.dart';
import 'package:fmfu/utils/cycle_generation.dart';
import 'package:fmfu/utils/cycle_rendering.dart';

typedef Cycles = List<List<RenderedObservation>>;

class CycleViewModel with ChangeNotifier {
  Cycles cycles = getCycles(CycleRecipe.standardRecipe, 10);

  void updateCycles(CycleRecipe recipe, int numCycles) {
    cycles = getCycles(recipe, numCycles);
    notifyListeners();
  }

  static Cycles getCycles(CycleRecipe  recipe, int numCycles) {
    return List.generate(numCycles, (index) => renderObservations(recipe.getObservations()));
  }
}