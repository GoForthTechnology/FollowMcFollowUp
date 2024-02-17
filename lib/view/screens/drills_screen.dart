import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
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
    return const Column(children: [
      StampSelectionPanel(),
      ChartCorrectingPanel(),
    ],);
  }
}

class StampSelectionPanel extends StatelessWidget {
  const StampSelectionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableInfoPanel(
      title: "Stamp Selection",
      subtitle: "Select the correct stamp for each day in the cycle",
      contents: dynamicExerciseList.map((exercise) => TextButton(
        onPressed: exercise.recipe == null ? null : () {
          AutoRouter.of(context).push(ChartCorrectingScreenRoute(
              cycle: exercise.getState(includeErrorScenarios: false).cycles.last));
        },
        child: Text(exercise.name),
      )).toList(),
    );
  }
}

class ChartCorrectingPanel extends StatelessWidget {
  const ChartCorrectingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableInfoPanel(
      title: "Chart Correcting",
      subtitle: "Find and correct all the errors in the provided chart",
      contents: dynamicExerciseList.map((exercise) => TextButton(
        onPressed: exercise.recipe == null ? null : () {
          AutoRouter.of(context).push(FollowUpSimulatorPageRoute(
              exerciseState: exercise.getState(includeErrorScenarios: true)));
        },
        child: Text(exercise.name),
      )).toList(),
    );
  }
}