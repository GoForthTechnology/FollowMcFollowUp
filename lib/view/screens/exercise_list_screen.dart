import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  Widget _tile({
    required Color color,
    required String title,
    required IconData icon,
    required String text,
    required Function() onClick,
  }) {
    return GestureDetector(onTap: onClick, child: Container(
      padding: const EdgeInsets.all(8),
      color: color,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        const Spacer(),
        Icon(icon, size: 50,),
        const Spacer(),
        Text(text),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
      ),
      body: Consumer<ExerciseListViewModel>(builder: (context, model, child) {
        model.getExercises(ExerciseType.dynamic);
        var customExercises = Future.wait([
          model.getCustomExercises(ExerciseType.dynamic),
          model.getCustomExercises(ExerciseType.static),
        ]);
        return FutureBuilder(
          future: customExercises,
          builder: ((context, snapshot) {
            Widget tile(Exercise e, bool isCustom) {
              return _tile(
                color: isCustom ? Colors.pinkAccent : Colors.lightBlue,
                onClick: () {
                  AutoRouter.of(context).push(
                      FollowUpSimulatorPageRoute(exerciseState: e.getState()));
                },
                icon: Icons.person,
                title: e.name,
                text: "",
              );
            }
            var scenarios = dynamicExerciseList.map((e) => tile(e, false)).toList();
            var exercises = staticExerciseList.map((e) => tile(e, false)).toList();
            if (snapshot.hasData) {
              List<List<Exercise>> customExercises = snapshot.data! as List<List<Exercise>>;
              scenarios.addAll(customExercises[0].map((e) => tile(e, true)).toList());
              exercises.addAll(customExercises[1].map((e) => tile(e, true)).toList());
            }
            return Center(child: ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 400), child: Column(children: [
              const Text("Scenarios", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Expanded(child: GridView.extent(
                primary: false,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300.0,
                children: scenarios,
              )),
              const Text("Exercises", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Expanded(child: GridView.extent(
                primary: false,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300.0,
                children: exercises,
              )),
            ])));
          }),
        );
      }),
    );
  }

}
