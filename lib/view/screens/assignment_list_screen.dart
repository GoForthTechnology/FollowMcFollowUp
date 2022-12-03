import 'package:flutter/material.dart';
import 'package:fmfu/model/assignment.dart';

class AssignmentListScreen extends StatelessWidget {
  const AssignmentListScreen({super.key});

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
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
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
        title: const Text("Assignments"),
      ),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 400), child: GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 300.0,
        children: assignments.map((assignment) => _tile(
          color: assignment.enabled ? Colors.lightBlue : Colors.grey[300]!,
          icon: Icons.person,
          title: "Pre-Client Assignment #${assignment.num}",
          text: assignment.enabled ? "" : "Coming Soon",
          onClick: () {
            //AutoRouter.of(context).push(const ExerciseScreenRoute());
          },
        )).toList(),
      ))),
    );
  }

}