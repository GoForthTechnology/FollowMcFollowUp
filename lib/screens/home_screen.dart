
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/navigation_rail_screen.dart';
import 'package:loggy/loggy.dart';

class HomeScreen extends StatelessWidget with UiLoggy {
  const HomeScreen({super.key});

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

  Widget content(BuildContext context) {
    final router = AutoRouter.of(context);
    return Center(child: ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 400), child: GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 300.0,
        children: <Widget>[
          _tile(
            color: Colors.lightBlue,
            icon: Icons.timer,
            title: "Drills",
            text: "Hone your skills with dynamic exercises",
            onClick: () => router.push(const DrillsScreenRoute()),
          ),
          _tile(
            color: Colors.lightBlue,
            icon: Icons.assignment,
            title: "Assignments",
            text: "Complete your pre-client assignments",
            onClick: () {
              const snackBar = SnackBar(content: Text("Coming soon"));
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          ),
          _tile(
            color: Colors.lightBlue,
            icon: Icons.person,
            title: "Clients",
            text: "Manage your clients and followups",
            onClick: () {
              const snackBar = SnackBar(content: Text("Coming soon"));
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          ),
          _tile(
            color: Colors.lightBlue,
            icon: Icons.school,
            title: "Programs",
            text: "Manage your education programs",
            onClick: () => router.push(const ProgramListScreenRoute()),
          ),
          _tile(
            color: Colors.grey[300]!,
            icon: Icons.engineering,
            title: "Follow Up Form",
            text: "Explore the follow up form (under construction).",
            onClick: () => router.push(FupFormScreenRoute()),
          ),
        ],
      )));
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRailScreen(
        title: const Text("Your Overview"),
        item: NavigationItem.home,
        content: content(context),
    );
  }
}
