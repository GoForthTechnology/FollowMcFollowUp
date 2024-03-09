import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/utils/distributions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_machine/time_machine.dart';

part 'exercises.g.dart';

abstract class Exercise {
  final String name;

  const Exercise(this.name);

  bool get enabled;
  ExerciseState getState({required bool includeErrorScenarios});
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

@JsonSerializable(explicitToJson: true)
class ExerciseObservation {
  final StickerWithText? stamp;
  final String observationText;

  ExerciseObservation(this.observationText, this.stamp);

  factory ExerciseObservation.fromJson(Map<String, dynamic> json) => _$ExerciseObservationFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseObservationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StaticExercise extends Exercise {
  final List<List<ExerciseObservation>> cycles;

  const StaticExercise(super.name, this.cycles);

  @override
  bool get enabled => cycles.isNotEmpty;

  @override
  ExerciseState getState({required bool includeErrorScenarios}) {
    List<Cycle> cycles = [];
    for (var observations in this.cycles) {
      final entries = observations.map((o) =>
          ChartEntry(
            observationText: o.observationText,
            additionalText: "",
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

  factory StaticExercise.fromJson(Map<String, dynamic> json) => _$StaticExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$StaticExerciseToJson(this);
}
const preBuildUpLengthRange = UniformRange(4, 6);

final basicErrorScenarios = {
  ErrorScenario.forgetObservationOnBleeding: 0.3,
  ErrorScenario.forgetD4: 0.3,
  ErrorScenario.forgetD5: 0.3,
};

const String splitPeakRecipe = '{"flowRecipe":{"maxFlow":"heavy","minFlow":"veryLight","flowLength":{"mean":5,"stdDev":1},"dischargeSummaryGenerator":{"typicalDischarge":{"dischargeType":"dry","dischargeDescriptors":[],"dischargeFrequencies":["allDay"]},"alternatives":[{"generator":{"typicalDischarge":{"dischargeType":"sticky","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["twice"]},"alternatives":[]},"probability":0.1},{"generator":{"typicalDischarge":{"dischargeType":"stretchy","dischargeDescriptors":["clear"],"dischargeFrequencies":["twice"]},"alternatives":[]},"probability":0}]}},"preBuildUpRecipe":{"length":{"mean":4,"stdDev":1},"nonMucusDischargeGenerator":{"typicalDischarge":{"dischargeType":"dry","dischargeDescriptors":[],"dischargeFrequencies":["allDay"]},"alternatives":[{"generator":{"typicalDischarge":{"dischargeType":"sticky","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["twice"]},"alternatives":[]},"probability":0.1},{"generator":{"typicalDischarge":{"dischargeType":"stretchy","dischargeDescriptors":["clear"],"dischargeFrequencies":["twice"]},"alternatives":[]},"probability":0}]},"abnormalBleedingGenerator":{"probability":0}},"buildUpRecipe":{"lengthDist":{"mean":4,"stdDev":1},"peakTypeLengthDist":{"mean":4,"stdDev":2},"peakTypeDischargeGenerator":{"typicalDischarge":{"dischargeType":"stretchy","dischargeDescriptors":["clear"],"dischargeFrequencies":["twice"]},"alternatives":[{"generator":{"typicalDischarge":{"dischargeType":"tacky","dischargeDescriptors":["clear"],"dischargeFrequencies":["once"]},"alternatives":[]},"probability":0.5},{"generator":{"typicalDischarge":{"dischargeType":"stretchy","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["once"]},"alternatives":[]},"probability":0.5}]},"nonPeakTypeDischargeGenerator":{"typicalDischarge":{"dischargeType":"sticky","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["twice"]},"alternatives":[{"generator":{"typicalDischarge":{"dischargeType":"tacky","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["once"]},"alternatives":[]},"probability":0.5}]}},"postPeakRecipe":{"lengthDist":{"mean":12,"stdDev":1},"mucusLengthDist":{"mean":4,"stdDev":1},"mucusDischargeGenerator":{"typicalDischarge":{"dischargeType":"sticky","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["twice"]},"alternatives":[{"generator":{"typicalDischarge":{"dischargeType":"tacky","dischargeDescriptors":["clear"],"dischargeFrequencies":["once"]},"alternatives":[]},"probability":0.5}]},"nonMucusDischargeGenerator":{"typicalDischarge":{"dischargeType":"dry","dischargeDescriptors":[],"dischargeFrequencies":["allDay"]},"alternatives":[{"generator":{"typicalDischarge":{"dischargeType":"sticky","dischargeDescriptors":["cloudy"],"dischargeFrequencies":["twice"]},"alternatives":[]},"probability":0}]},"abnormalBleedingGenerator":{"probability":0},"preMenstrualSpottingLengthDist":{"mean":0,"stdDev":1}}}';

final dynamicExerciseList = [
  if (kDebugMode) DynamicExercise(name: "Short Test Cycles", recipe: CycleRecipe.create(
    flowLength: 2, preBuildUpLength: 2, peakTypeLength: 1, buildUpLength: 2, postPeakLength: 5,
  )),

  DynamicExercise(name: "Typical Cycles", recipe: CycleRecipe.create(
    prePeakMucusPatchProbability: 0.1,
  ), errorScenarios: basicErrorScenarios),

  DynamicExercise(
    name: "Split Peak",
    recipe: CycleRecipe.fromJson(jsonDecode(splitPeakRecipe)),
    errorScenarios: basicErrorScenarios,
  ),

  const DynamicExercise(name: "Over reading lubrication"),

  DynamicExercise(name: "Continuous Mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    prePeakMucusPatchProbability: 1.0,
    postPeakMucusPatchProbability: 1.0,
  ), errorScenarios: basicErrorScenarios),

  DynamicExercise(name: "Mucus Cycle > 8 days (reg. Cycles)", recipe: CycleRecipe.create(
    preBuildUpLength: 0,
    buildUpLength: const UniformRange(8, 10).get().round(),
  ), errorScenarios: basicErrorScenarios),

  const DynamicExercise(name: "Variable return of Peak-type mucus"),

  DynamicExercise(name: "Post-Peak, non-Peak-type mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    postPeakMucusPatchProbability: const UniformRange(0.7, 0.9).get(),
  ), errorScenarios: basicErrorScenarios),

  DynamicExercise(name: "Post-Peak Pasty", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    prePeakMucusPatchProbability: const UniformRange(0.6, 0.8).get(),
    postPeakPasty: true,
  ), errorScenarios: basicErrorScenarios),

  const DynamicExercise(name: "Post-Peak, Peak-type mucus"),

  DynamicExercise(name: "Premenstrual Spotting", recipe: CycleRecipe.create(
    preMenstrualSpottingLength: 4,
  ), errorScenarios: basicErrorScenarios),

  DynamicExercise(name: "Unusual Bleeding", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    unusualBleedingProbability: const UniformRange(0.2, 0.5).get(),
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnBleeding: 0.3,
    ErrorScenario.forgetRedStampForUnusualBleeding: 0.5,
    ErrorScenario.forgetCountOfThreeForUnusualBleeding: 0.9,
  }),

  DynamicExercise(name: "Limited Mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    buildUpLength: const UniformRange(1, 2).get().round(),
    peakTypeLength: const UniformRange(0, 1).get().round(),
  ), errorScenarios: basicErrorScenarios),
];

@JsonSerializable(explicitToJson: true)
class DynamicExercise extends Exercise {
  final CycleRecipe? recipe;
  @LocalDateJsonConverter()
  final LocalDate? startOfAskingEsQ;
  @LocalDateJsonConverter()
  final LocalDate? startOfPrePeakYellowStamps;
  @LocalDateJsonConverter()
  final LocalDate? startOfPostPeakYellowStamps;
  final Map<ErrorScenario, double> errorScenarios;

  const DynamicExercise({
    this.recipe,
    this.errorScenarios = const {},
    this.startOfAskingEsQ,
    this.startOfPrePeakYellowStamps,
    this.startOfPostPeakYellowStamps,
    name
  }) : super(name);

  @override
  bool get enabled => recipe != null;

  @override
  ExerciseState getState({required bool includeErrorScenarios}) {
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
    final firstCycleObservations = recipe!.getObservations(startingDate: startDate, startOfAskingEsQ: startOfAskingEsQ);
    final startingDayOffset = UniformRange(0, firstCycleObservations.length.toDouble()).get().round();

    var currentDate = startDate;
    final cycles = List.generate(6, (index) {
      final List<RenderedObservation> observations;
      if (index == 0) {
        observations = [];
        for (int i=0; i < startingDayOffset - 1; i++) {
          observations.add(RenderedObservation.blank(startDate.addDays(i)));
        }
        observations.addAll(renderObservations(
          firstCycleObservations.sublist(startingDayOffset),
          startOfPrePeakYellowStamps,
          startOfPostPeakYellowStamps,
          startDate: startDate.addDays(startingDayOffset),
        ));
      } else {
        observations = renderObservations(
          recipe!.getObservations(startingDate: currentDate, startOfAskingEsQ: startOfAskingEsQ),
          startOfPrePeakYellowStamps,
          startOfPostPeakYellowStamps,
          startDate: currentDate,
        );
      }
      currentDate = currentDate.addDays(observations.length);

      var entries = List.of(observations.map(ChartEntry.fromRenderedObservation));
      if (includeErrorScenarios) {
        entries = introduceErrors(entries, activeScenarios);
      }
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

  factory DynamicExercise.fromJson(Map<String, dynamic> json) => _$DynamicExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$DynamicExerciseToJson(this);
}

const followUpSequence = [14, 14, 14, 14, 28, 84, 84, 84];
