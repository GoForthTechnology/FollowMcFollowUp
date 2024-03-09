import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/screens/chart_editor_screen.dart';
import 'package:fmfu/utils/navigation_rail_screen.dart';
import 'package:fmfu/widgets/info_panel.dart';
import 'package:loggy/loggy.dart';

class DrillsScreen extends StatelessWidget {
  const DrillsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return NavigationRailScreen(
      title: const Text("Drills"),
      item: NavigationItem.drills,
      content: _content(context),
    );
  }
  
  Widget _content(BuildContext context) {
    List<Exercise> exercises = List.from(dynamicExerciseList)
      //..addAll(staticExerciseList) TODO: re-enable once the random selection bug is fixed
    ;
    return SingleChildScrollView(child: Column(children: [
      StampSelectionPanel(exercises: exercises,),
      ChartCorrectingPanel(exercises: exercises,),
      Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(onPressed: () {
          ChartEditorPage.route(context)
              .then((route) => AutoRouter.of(context).push(route));
        }, child: const Text("Create new drill")),
      ),
    ],));
  }
}

Exercise randomActiveExercise(List<Exercise> exercises) {
  var activeExercises = exercises.where((e) => e.enabled).toList();
  var index = Random().nextInt(activeExercises.length);
  var exercise = activeExercises[index];
  logDebug("Random exercise index $index out of ${activeExercises.length}, ${exercise.name}");
  return exercise;
}

class StampSelectionPanel extends StatelessWidget {
  final List<Exercise> exercises;

  const StampSelectionPanel({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    var randomExercise = TextButton(onPressed: () {
      AutoRouter.of(context).push(ChartCorrectingScreenRoute(
          cycle: randomActiveExercise(exercises).getState(includeErrorScenarios: true).cycles[1]));
    }, child: const Text("Random Exercise"));
    var exerciseWidgets = exercises.map((exercise) => TextButton(
      onPressed: exercise.enabled ? () {
        AutoRouter.of(context).push(ChartCorrectingScreenRoute(
            cycle: exercise.getState(includeErrorScenarios: false).cycles[1]));
      } : null,
      child: Text(exercise.name),
    )).toList();
    return ExpandableInfoPanel(
      title: "Stamp Selection",
      subtitle: "Select the correct stamp for each day in the cycle",
      contents: [randomExercise, ...exerciseWidgets],
    );
  }
}

class ChartCorrectingPanel extends StatelessWidget {
  final List<Exercise> exercises;

  const ChartCorrectingPanel({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    var randomExercise = TextButton(onPressed: () {
      AutoRouter.of(context).push(FollowUpSimulatorPageRoute(
          exerciseState: randomActiveExercise(exercises).getState(includeErrorScenarios: true)));
    }, child: const Text("Random Exercise"));
    var exerciseWidgets = exercises.map((exercise) => TextButton(
      onPressed: exercise.enabled ? () {
        AutoRouter.of(context).push(FollowUpSimulatorPageRoute(
            exerciseState: exercise.getState(includeErrorScenarios: true)));
      } : null,
      child: Text(exercise.name),
    )).toList();
    return ExpandableInfoPanel(
      title: "Chart Correcting",
      subtitle: "Find and correct all the errors in the provided chart",
      contents: [randomExercise, ...exerciseWidgets],
    );
  }
}