
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:loggy/loggy.dart';
import 'package:time_machine/time_machine.dart';

const staticExerciseList = [
  StaticExercise("Book 1: Figure 11-1"),
  StaticExercise("Book 1: Figure 11-2"),
  StaticExercise("Book 1: Figure 11-3"),
  StaticExercise("Book 1: Figure 11-4"),
];

final dynamicExerciseList = [
  const DynamicExercise(name: "Over reading lubrication"),
  DynamicExercise(name: "Continuous Mucus", recipe: CycleRecipe.create(
    prePeakMucusPatchProbability: 1.0,
    postPeakMucusPatchProbability: 1.0,
  )),
  const DynamicExercise(name: "Mucus Cycle > 8 days (reg. Cycles)"),
  const DynamicExercise(name: "Variable return of Peak-type mucus"),
  DynamicExercise(name: "Post-Peak, non-Peak-type mucus", recipe: CycleRecipe.create(
    postPeakMucusPatchProbability: 0.6,
  )),
  const DynamicExercise(name: "Post-Peak Pasty"),
  const DynamicExercise(name: "Post-Peak, Peak-type mucus"),
  const DynamicExercise(name: "Premenstrual Spotting"),
  DynamicExercise(name: "Unusual Bleeding",recipe: CycleRecipe.create(
    unusualBleedingProbability: 0.6,
  )),
  const DynamicExercise(name: "Limited Mucus"),
];

abstract class Exercise {
  final String name;

  const Exercise(this.name);

  bool get enabled;
  ExerciseState getState();
}

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

class DynamicExercise extends Exercise {
  final CycleRecipe? recipe;

  const DynamicExercise({this.recipe, name}) : super(name);

  @override
  bool get enabled => recipe != null;

  @override
  ExerciseState getState() {
    if (recipe == null) {
      throw StateError("Should not try and get state with a null recipe!");
    }
    var cycles = List.generate(6, (index) => Cycle(
      index: index,
      entries: List.of(renderObservations(recipe!.getObservations(), [])
          .map((o) => ChartEntry(renderedObservation: o, observationText: o.observationText))),
    ));
    return ExerciseState([], [], cycles, [], LocalDate.today());
  }
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
