import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/navigation_rail_screen.dart';
import 'package:fmfu/view/widgets/info_panel.dart';

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
      ..addAll(staticExerciseList);
    return Column(children: [
      StampSelectionPanel(exercises: exercises,),
      ChartCorrectingPanel(exercises: exercises,),
    ],);
  }
}

class StampSelectionPanel extends StatelessWidget {
  final List<Exercise> exercises;

  const StampSelectionPanel({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return ExpandableInfoPanel(
      title: "Stamp Selection",
      subtitle: "Select the correct stamp for each day in the cycle",
      contents: exercises.map((exercise) => TextButton(
        onPressed: exercise.enabled ? () {
          AutoRouter.of(context).push(ChartCorrectingScreenRoute(
              cycle: exercise.getState(includeErrorScenarios: false).cycles[1]));
        } : null,
        child: Text(exercise.name),
      )).toList(),
    );
  }
}

class ChartCorrectingPanel extends StatelessWidget {
  final List<Exercise> exercises;

  const ChartCorrectingPanel({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return ExpandableInfoPanel(
      title: "Chart Correcting",
      subtitle: "Find and correct all the errors in the provided chart",
      contents: exercises.map((exercise) => TextButton(
        onPressed: exercise.enabled ? null : () {
          AutoRouter.of(context).push(FollowUpSimulatorPageRoute(
              exerciseState: exercise.getState(includeErrorScenarios: true)));
        },
        child: Text(exercise.name),
      )).toList(),
    );
  }
}