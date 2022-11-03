
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/distributions.dart';
import 'package:loggy/loggy.dart';
import 'package:time_machine/time_machine.dart';

class StaticExerciseListScreen extends ExerciseListScreen {
  const StaticExerciseListScreen({super.key}) : super(exercises: staticExerciseList);
}

const staticExerciseList = [
  StaticExercise("Book 1: Figure 11-1"),
  StaticExercise("Book 1: Figure 11-2"),
  StaticExercise("Book 1: Figure 11-3"),
  StaticExercise("Book 1: Figure 11-4"),
];

class StaticExercise extends Exercise {
  const StaticExercise(super.name);

  @override
  bool get enabled => false;

  @override
  ExerciseState getState() {
    // TODO: implement getState
    throw UnimplementedError();
  }
}
class DynamicExerciseListScreen extends ExerciseListScreen {
  DynamicExerciseListScreen({super.key}) : super(exercises: dynamicExerciseList);
}

const preBuildUpLengthRange = UniformRange(4, 6);

final dynamicExerciseList = [
  const DynamicExercise(name: "Over reading lubrication"),
  DynamicExercise(name: "Continuous Mucus", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
    prePeakMucusPatchProbability: 1.0,
    postPeakMucusPatchProbability: 1.0,
  ), errorScenarios: {
    ErrorScenario.forgetObservationOnFlow: 0.3,
  }),
  DynamicExercise(name: "Mucus Cycle > 8 days (reg. Cycles)", recipe: CycleRecipe.create(
    preBuildUpLength: preBuildUpLengthRange.get().round(),
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
  const DynamicExercise(name: "Post-Peak Pasty"),
  const DynamicExercise(name: "Post-Peak, Peak-type mucus"),
  const DynamicExercise(name: "Premenstrual Spotting"),
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

    print("Starting day offset: ${startingDayOffset.toString()}");

    var currentDate = startDate;
    final cycles = List.generate(6, (index) {
      final List<RenderedObservation> observations;
      if (index == 0) {
        print("Starting with ${firstCycleObservations.length} observations");
        observations = [];
        for (int i=0; i < startingDayOffset - 1; i++) {
          observations.add(RenderedObservation.blank(startDate.addDays(i)));
        }
        print("Blanked ${observations.length} days");
        observations.addAll(renderObservations(firstCycleObservations.sublist(startingDayOffset), [], startDate: startDate.addDays(startingDayOffset)));
        print("Final total ${observations.length}");
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

class ExerciseListScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const ExerciseListScreen({super.key, required this.exercises});

  @override
  State<StatefulWidget> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> with GlobalLoggy {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise List"),
      ),
      body: ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          return Padding(padding: const EdgeInsets.all(10), child: Row(children: [
            const Spacer(),
            ElevatedButton(
              onPressed: exercise.enabled ? () {
                AutoRouter.of(context).push(FollowUpSimulatorPageRoute(exerciseState: exercise.getState()));
              } : null,
              child: Padding(padding: const EdgeInsets.all(10), child: Text(
                exercise.name,
                style: const TextStyle(fontSize: 18),
              )),
            ),
            const Spacer(),
          ]));
        },
      ),
    );
  }
}
