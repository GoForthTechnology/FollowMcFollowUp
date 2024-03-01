
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/educator_profile.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/navigation_rail_screen.dart';
import 'package:fmfu/screens/chart_editor_screen.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

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

  Widget content(BuildContext context, EducatorProfile? educatorProfile) {
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
              icon: Icons.edit,
              title: "Exercise Builder",
              text: "Create an exercise.",
              onClick: () async {
                ChartEditorPage.route(context).then((route) => router.push(route));
              }
          ),
          _tile(
            color: Colors.lightBlue,
            icon: Icons.assignment,
            title: "Assignments",
            text: "Complete your pre-client assignments",
            onClick: () => router.push(const AssignmentListScreenRoute()),
          ),
          _tile(
            color: Colors.grey[300]!,
            icon: Icons.engineering,
            title: "Follow Up Form",
            text: "Under construction.",
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
        content: Consumer<UserService>(builder: (context, userService, _) => FutureProvider<EducatorProfile?>(
      create: (_) => userService.getOrCreateEducatorProfile(),
      initialData: null,
      child: Consumer<EducatorProfile?>(builder: (context, educatorProfile, _) => content(context, educatorProfile)),
    )));
  }
}
