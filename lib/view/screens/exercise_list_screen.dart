

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:loggy/loggy.dart';

class StaticExerciseListScreen extends ExerciseListScreen {
  StaticExerciseListScreen({super.key}) : super(exercises: staticExerciseList);
}

class DynamicExerciseListScreen extends ExerciseListScreen {
  DynamicExerciseListScreen({super.key}) : super(exercises: dynamicExerciseList);
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
