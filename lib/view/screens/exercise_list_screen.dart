import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

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
        return LayoutBuilder(builder: (context , constraints ) => FutureBuilder(
          future: customExercises,
          builder: ((context, snapshot) {
            Widget tile(Exercise e, bool isCustom) {
              Color color;
              if (!e.enabled) {
                color = Colors.grey[300]!;
              } else if (isCustom) {
                color = Colors.pinkAccent;
              } else {
                color = Colors.lightBlue;
              }
              return _tile(
                color: color,
                onClick: e.enabled ? () {
                  AutoRouter.of(context).push(
                      FollowUpSimulatorPageRoute(exerciseState: e.getState()));
                } : () {
                  const snackBar = SnackBar(
                    content: Text("Coming Soon!"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: e.enabled ? Icons.person : Icons.engineering,
                title: e.name,
                text: e.enabled ? "Some description here." : "Under Construction",
              );
            }
            var scenarios = dynamicExerciseList.map((e) => tile(e, false)).toList();
            var exercises = staticExerciseList.map((e) => tile(e, false)).toList();
            if (snapshot.hasData) {
              List<List<Exercise>> customExercises = snapshot.data! as List<List<Exercise>>;
              scenarios.addAll(customExercises[0].map((e) => tile(e, true)).toList());
              exercises.addAll(customExercises[1].map((e) => tile(e, true)).toList());
            }
            final scrollView = CustomScrollView(
              slivers: [
                _makeHeader("Scenarios", "Each exercise is a random chart which exhibits certain characteristics."),
                _makeGrid(scenarios, constraints),
                _makeHeader("Exercises", "Each exercise has the same preconfigured chart."),
                _makeGrid(exercises, constraints),
              ],
            );
            return Center(child: scrollView);
          }),
        ));
      }),
    );
  }

  Widget _tile({
    required Color color,
    required String title,
    required IconData icon,
    required String text,
    required Function()? onClick,
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

  SliverPersistentHeader _makeHeader(String headerText, String subTitle) {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: Center(child: Column(children: [
          Text(headerText, style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          )),
          Text(subTitle),
        ])),
      ),
    );
  }

  Widget _makeGrid(List<Widget> children, BoxConstraints constraints) {
    const gridWidth = 400;
    double paddingWidth = max((constraints.maxWidth - gridWidth) / 2, 0);
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: max(paddingWidth, 15),
      ),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: children,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}