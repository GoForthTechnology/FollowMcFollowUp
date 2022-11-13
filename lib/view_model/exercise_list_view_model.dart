import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/utils/distributions.dart';
import 'package:time_machine/time_machine.dart';

class ExerciseListViewModel extends ChangeNotifier {
  final Map<String, StaticExercise> _customStaticExercises = {};
  final Map<String, DynamicExercise> _customDynamicExercises = {};

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
    switch (exerciseType) {
      case ExerciseType.static:
        return _customStaticExercises.values.toList();
      case ExerciseType.dynamic:
        return _customDynamicExercises.values.toList();
    }
  }

  bool hasCustomExercise(String name, ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.static:
        return _customStaticExercises.containsKey(name);
      case ExerciseType.dynamic:
        return _customDynamicExercises.containsKey(name);
    }
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
        _customStaticExercises[name] = StaticExercise(name, cycles);
        break;
      case ExerciseType.dynamic:
        _customDynamicExercises[name] = DynamicExercise(
          name: name,
          recipe: recipe,
          errorScenarios: errorScenarios,
        );
        break;
    }
    notifyListeners();
  }
}

enum ExerciseType {
  static, dynamic
}

final staticExerciseList = [
  StaticExercise("Book 1: Figure 11-3", [[
    ExerciseObservation("L", StickerWithText(Sticker.red, null)),
    ExerciseObservation("H", StickerWithText(Sticker.red, null)),
    ExerciseObservation("H", StickerWithText(Sticker.red, null)),
    ExerciseObservation("M", StickerWithText(Sticker.red, null)),
    ExerciseObservation("L", StickerWithText(Sticker.red, null)),
    ExerciseObservation("0", StickerWithText(Sticker.green, null)),
    ExerciseObservation("2x1", StickerWithText(Sticker.green, null)),
    ExerciseObservation("2x1", StickerWithText(Sticker.green, null)),
    ExerciseObservation("4k", null),
    ExerciseObservation("6pcx2", StickerWithText(Sticker.green, null)),
    ExerciseObservation("6c", null),
    ExerciseObservation("2ad", StickerWithText(Sticker.green, null)),
    ExerciseObservation("", null),
    ExerciseObservation("0", null),
    ExerciseObservation("10c/k", StickerWithText(Sticker.whiteBaby, null)),
    ExerciseObservation("10lk AD", StickerWithText(Sticker.whiteBaby, null)),
    ExerciseObservation("10lk AD", StickerWithText(Sticker.whiteBaby, "P")),
    ExerciseObservation("8k x1", StickerWithText(Sticker.greenBaby, "1")),
    ExerciseObservation("8k", StickerWithText(Sticker.greenBaby, "2")),
    ExerciseObservation("6c x2", StickerWithText(Sticker.greenBaby, "3")),
    ExerciseObservation("0", StickerWithText(Sticker.green, null)),
    ExerciseObservation("0", StickerWithText(Sticker.green, null)),
    ExerciseObservation("2AD", StickerWithText(Sticker.green, null)),
    ExerciseObservation("0", StickerWithText(Sticker.green, null)),
    ExerciseObservation("0", StickerWithText(Sticker.green, null)),
    ExerciseObservation("10SL", StickerWithText(Sticker.whiteBaby, null)),
    ExerciseObservation("0", StickerWithText(Sticker.green, null)),
    ExerciseObservation("10SL", StickerWithText(Sticker.whiteBaby, null)),
    ExerciseObservation("10SL", StickerWithText(Sticker.whiteBaby, null)),
    ExerciseObservation("2AD", StickerWithText(Sticker.green, null)),
    ExerciseObservation("2AD", StickerWithText(Sticker.green, null)),
    ExerciseObservation("2AD", StickerWithText(Sticker.green, null)),
    ExerciseObservation("10K", StickerWithText(Sticker.green, null)),
    ExerciseObservation("L", StickerWithText(Sticker.red, null)),
  ]]),
  const StaticExercise("Book 1: Figure 11-4", []),
];

class ExerciseObservation {
  final StickerWithText? stamp;
  final String observationText;

  ExerciseObservation(this.observationText, this.stamp);
}

class StaticExercise extends Exercise {
  final List<List<ExerciseObservation>> cycles;

  const StaticExercise(super.name, this.cycles);

  @override
  bool get enabled => cycles.isNotEmpty;

  @override
  ExerciseState getState() {
    List<Cycle> cycles = [];
    for (var observations in this.cycles) {
      final entries = observations.map((o) =>
          ChartEntry(
            observationText: o.observationText,
            manualSticker: o.stamp ?? StickerWithText(Sticker.white, null),
          )).toList();
      cycles.add(Cycle(
        index: 0,
        entries: entries,
        stickerCorrections: {},
        observationCorrections: {},
      ));
    }
    return ExerciseState([], {}, cycles, [], LocalDate.today());
  }
}
const preBuildUpLengthRange = UniformRange(4, 6);

final dynamicExerciseList = [
  DynamicExercise(name: "Typical Cycles", recipe: CycleRecipe.create()),

  const DynamicExercise(name: "Over reading lubrication"),

  DynamicExercise(name: "Continuous Mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    prePeakMucusPatchProbability: 1.0,
    postPeakMucusPatchProbability: 1.0,
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),

  DynamicExercise(name: "Mucus Cycle > 8 days (reg. Cycles)", recipe: CycleRecipe.create(
    preBuildUpLength: 0,
    buildUpLength: const UniformRange(8, 10).get().round(),
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),

  const DynamicExercise(name: "Variable return of Peak-type mucus"),

  DynamicExercise(name: "Post-Peak, non-Peak-type mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    postPeakMucusPatchProbability: const UniformRange(0.7, 0.9).get(),
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),

  DynamicExercise(name: "Post-Peak Pasty", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    prePeakMucusPatchProbability: const UniformRange(0.6, 0.8).get(),
    postPeakPasty: true,
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),

  const DynamicExercise(name: "Post-Peak, Peak-type mucus"),

  DynamicExercise(name: "Premenstrual Spotting", recipe: CycleRecipe.create(
    preMenstrualSpottingLength: 4,
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),

  DynamicExercise(name: "Unusual Bleeding", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    unusualBleedingProbability: const UniformRange(0.6, 0.9).get(),
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
    ErrorScenario.forgetRedStampForUnusualBleeding: 0.5,
    ErrorScenario.forgetCountOfThreeForUnusualBleeding: 0.7,
  }),

  DynamicExercise(name: "Limited Mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    buildUpLength: const UniformRange(1, 2).get().round(),
    peakTypeLength: const UniformRange(0, 1).get().round(),
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),
];

const followUpSequence = [14, 14, 14, 14, 28, 84, 84, 84];

class DynamicExercise extends Exercise {
  final CycleRecipe? recipe;
  final Map<ErrorScenario, double> errorScenarios;

  const DynamicExercise({this.recipe, this.errorScenarios = const {}, name}) : super(name);

  @override
  bool get enabled => recipe != null;

  @override
  ExerciseState getState() {
    if (recipe == null) {
      throw StateError("Should not try and get state with a null recipe!");
    }
    final random = Random();
    Set<ErrorScenario> activeScenarios = {};
    errorScenarios.forEach((scenario, probability) {
      if (random.nextDouble() <= probability) {
        activeScenarios.add(scenario);
      }
    });

    final startDate = LocalDate(LocalDate.today().year, 1, 1);
    final firstCycleObservations = recipe!.getObservations();
    final startingDayOffset = UniformRange(0, firstCycleObservations.length.toDouble()).get().round();

    var currentDate = startDate;
    final cycles = List.generate(6, (index) {
      final List<RenderedObservation> observations;
      if (index == 0) {
        observations = [];
        for (int i=0; i < startingDayOffset - 1; i++) {
          observations.add(RenderedObservation.blank(startDate.addDays(i)));
        }
        observations.addAll(renderObservations(firstCycleObservations.sublist(startingDayOffset), [], startDate: startDate.addDays(startingDayOffset)));
      } else {
        observations = renderObservations(recipe!.getObservations(), [], startDate: currentDate);
      }
      currentDate = currentDate.addDays(observations.length);

      var entries = List.of(observations.map((o) => ChartEntry(
          renderedObservation: o, observationText: o.observationText)));
      entries = introduceErrors(entries, activeScenarios);
      return Cycle(
        index: index,
        entries: entries,
        observationCorrections: {},
        stickerCorrections: {},
      );
    });

    final startingDay = startDate.addDays(startingDayOffset - 1);

    List<LocalDate> followUps = [];
    var elapsedDays = 0;
    for (int i=0; i < followUpSequence.length; i++) {
      elapsedDays += followUpSequence[i];
      followUps.add(startingDay.addDays(elapsedDays));
    }
    return ExerciseState([], activeScenarios, cycles, followUps, startingDay);
  }
}

abstract class Exercise {
  final String name;

  const Exercise(this.name);

  bool get enabled;
  ExerciseState getState();
}
