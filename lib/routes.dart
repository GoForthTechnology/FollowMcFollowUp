import 'package:auto_route/auto_route.dart';
import 'package:fmfu/view/screens/chart_correction_screen.dart';
import 'package:fmfu/view/screens/chart_editor_screen.dart';
import 'package:fmfu/view/screens/fup_simulator_screen.dart';
import 'package:fmfu/view/screens/fupf_screen.dart';
import 'package:fmfu/view/screens/home_screen.dart';
import 'package:fmfu/view/screens/landing_screen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      path: '/',
      page: LandingScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/home',
      page: HomeScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/followup_form',
      page: FupFormScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/simulator',
      page: FollowUpSimulatorPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/editor',
      page: ChartEditorPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/correction',
      page: ChartCorrectingScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    // redirect all other paths
    RedirectRoute(path: '*', redirectTo: '/'),
    //Home
  ],
)
class $AppRouter {}