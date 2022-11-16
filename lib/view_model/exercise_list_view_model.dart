
import 'package:flutter/cupertino.dart';
import 'package:fmfu/api/exercise_service.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';

class ExerciseListViewModel extends ChangeNotifier {
  final ExerciseService _exerciseService = LocalExerciseService();

  int numExercises(ExerciseType exerciseType) {
    return getExercises(exerciseType).length + getCustomExercises(exerciseType).length;
  }

  List<Exercise> getExercises(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.static:
        return staticExerciseList;
      case ExerciseType.dynamic:
        return dynamicExerciseList;
    }
  }

  List<Exercise> getCustomExercises(ExerciseType exerciseType) {
    return _exerciseService.getCustomExercises(exerciseType);
  }

  bool hasCustomExercise(String name, ExerciseType exerciseType) {
    return _exerciseService.hasCustomExercise(name, exerciseType);
  }

  void addCustomExercise({
    required String name,
    required ExerciseType exerciseType,
    required Chart chart,
    CycleRecipe? recipe,
    Map<ErrorScenario, double> errorScenarios = const {},
  }) {
    switch (exerciseType) {
      case ExerciseType.static:
        var cycles = chart.cycles
            .where((slice) => slice.cycle != null)
            .map((slice) => slice.cycle!.entries
                .map((entry) => ExerciseObservation(
                    entry.observationText,
                    entry.manualSticker ?? StickerWithText(
                        entry.renderedObservation?.getSticker() ?? Sticker.white,
                        entry.renderedObservation?.getStickerText())))
                .toList())
            .toList();
        _exerciseService.updateCustomStaticExercise(name, StaticExercise(name, cycles));
        break;
      case ExerciseType.dynamic:
        _exerciseService.updateCustomDynamicExercise(name, DynamicExercise(
          name: name,
          recipe: recipe,
          errorScenarios: errorScenarios,
        ));
        break;
    }
    notifyListeners();
  }
}
