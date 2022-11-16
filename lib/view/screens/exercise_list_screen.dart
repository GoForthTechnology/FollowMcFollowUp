

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/screen_widget.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:provider/provider.dart';

class StaticExerciseListScreen extends ExerciseListScreen {
  StaticExerciseListScreen({super.key}) : super(ExerciseType.static);
}

class DynamicExerciseListScreen extends ExerciseListScreen {
  DynamicExerciseListScreen({super.key}) : super(ExerciseType.dynamic);
}

class ExerciseListScreen extends ScreenWidget {
  final ExerciseType exerciseType;

  ExerciseListScreen(this.exerciseType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Exercise List"),
        ),
        body: Consumer<ExerciseListViewModel>(builder: (context, exerciseModel, child) {
          List<Exercise> exercises = exerciseModel.getExercises(exerciseType);
          List<Exercise> customExercises = exerciseModel.getCustomExercises(exerciseType);
          int numItems = exercises.length + customExercises.length;
          return ListView.builder(
            itemCount: numItems,
            itemBuilder: (context, index) {
              final Exercise exercise;
              final isCustom = index >= exercises.length;
              if (isCustom) {
                exercise = customExercises[index-exercises.length];
              } else {
                exercise = exercises[index];
              }
              return Padding(padding: const EdgeInsets.all(10), child: Row(children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: exercise.enabled ? () {
                    AutoRouter.of(context).push(FollowUpSimulatorPageRoute(exerciseState: exercise.getState()));
                  } : null,
                  child: Padding(padding: const EdgeInsets.all(10), child: Text(
                    isCustom ? "Custom: ${exercise.name}" : exercise.name,
                    style: const TextStyle(fontSize: 18),
                  )),
                ),
                const Spacer(),
              ]));
            },
          );
        }),
        );
  }
}
