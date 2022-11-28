
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/api/exercise_service.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';

class ExerciseListViewModel extends ChangeNotifier with GlobalLoggy {
  late ExerciseService _exerciseService;

  ExerciseListViewModel(FirebaseAuth auth) {
    loggy.debug("Initializing with user: ${auth.currentUser != null}");
    _exerciseService = ExerciseService.create(auth.currentUser);
    auth.authStateChanges().forEach((user) {
      loggy.debug("Re-initializing service with user: ${user != null}");
      _exerciseService = ExerciseService.create(user);
    });
  }

  Future<List<DynamicExercise>> getTemplates() async {
    var exercises = getExercises(ExerciseType.dynamic).where((e) => e.enabled).toList();
    exercises.addAll(await getCustomExercises(ExerciseType.dynamic));
    return exercises as List<DynamicExercise>;
  }

  Future<int> numExercises(ExerciseType exerciseType) async {
    int numExercises = getExercises(exerciseType).length;
    int numCustomExercises = getExercises(exerciseType).length;
    return numExercises + numCustomExercises;
  }

  List<Exercise> getExercises(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.static:
        return staticExerciseList;
      case ExerciseType.dynamic:
        return dynamicExerciseList;
    }
  }

  Future<List<Exercise>> getCustomExercises(ExerciseType exerciseType) {
    return _exerciseService.getCustomExercises(exerciseType);
  }

  Future<void> removeExercise(String name, ExerciseType exerciseType) {
    return _exerciseService.removeExercise(name, exerciseType)
        .whenComplete(() => notifyListeners());
  }

  Future<void> addCustomExercise({
    required String name,
    required ExerciseType exerciseType,
    required Chart chart,
    CycleRecipe? recipe,
    Map<ErrorScenario, double> errorScenarios = const {},
  }) async {
    if (await _exerciseService.hasCustomExercise(name, exerciseType)) {
      throw Exception("Exercise already exists with name '$name'");
    }
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
        return _exerciseService.updateCustomStaticExercise(name, StaticExercise(name, cycles))
            .then((value) => notifyListeners());
      case ExerciseType.dynamic:
        return _exerciseService.updateCustomDynamicExercise(name, DynamicExercise(
          name: name,
          recipe: recipe,
          errorScenarios: errorScenarios,
        )).then((value) => notifyListeners());
    }
  }
}
