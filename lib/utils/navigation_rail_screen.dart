import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/routes.gr.dart';

enum NavigationItem {
  home(label: "Home", icon: Icons.home, route: HomeScreenRoute()),
  drills(label: "Drills", icon: Icons.timer, route: DrillsScreenRoute()),
  assignments(label: "Assignments", icon: Icons.assignment),
  clients(label: "Clients", icon: Icons.person),
  programs(label: "My Programs", icon: Icons.school, route: ProgramListScreenRoute()),
  ;

  final String label;
  final IconData icon;
  final PageRouteInfo? route;

  const NavigationItem({required this.label, required this.icon, this.route});
}

class NavigationRailScreen extends StatelessWidget {
  final NavigationItem item;
  final Widget title;
  final Widget? fab;
  final Widget content;

  const NavigationRailScreen({super.key, required this.item, required this.content, required this.title, this.fab});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logScreenView(screenName: item.label);

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut()
              .then((x) => AutoRouter.of(context).pushAndPopUntil(const LoginScreenRoute(), predicate: (r) => false)),
          ),
        ],
      ),
      body: _showRail(context) ? _railLayout(context) : content,
      floatingActionButton: fab,
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  bool _showRail(BuildContext context) {
    return MediaQuery.of(context).size.width >= 640;
  }

  Widget _railLayout(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      NavigationRail(
        selectedIndex: item.index,
        destinations: NavigationItem.values.map((i) => NavigationRailDestination(
          icon: Tooltip(message: i.name, child: Icon(i.icon)),
          label: Text(i.label),
        )).toList(),
        onDestinationSelected: (index) => _onSelect(context, index),
      ),
      Expanded(child: content),
    ],);
  }

  Widget? _bottomNavBar(BuildContext context) {
    if (_showRail(context)) {
      return null;
    }
    return NavigationBar(
      onDestinationSelected: (index) => _onSelect(context, index),
      selectedIndex: item.index,
      destinations: NavigationItem.values
          .map((i) => NavigationDestination(icon: Icon(i.icon), label: i.label))
          .toList(),
    );
  }

  void _onSelect(BuildContext context, int index) {
    var item = NavigationItem.values[index];
    if (item.route != null) {
      AutoRouter.of(context).popAndPush(item.route!);
    } else {
      const snackBar = SnackBar(content: Text("Coming Soon!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}