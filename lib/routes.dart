import 'package:auto_route/auto_route.dart';
import 'package:fmfu/auth.dart';
import 'package:fmfu/view/screens/assignment_detail_screen.dart';
import 'package:fmfu/view/screens/assignment_list_screen.dart';
import 'package:fmfu/view/screens/chart_correction_screen.dart';
import 'package:fmfu/view/screens/chart_editor_screen.dart';
import 'package:fmfu/view/screens/education_program_crud_screen.dart';
import 'package:fmfu/view/screens/education_program_list_screen.dart';
import 'package:fmfu/view/screens/email_verify_screen.dart';
import 'package:fmfu/view/screens/exercise_list_screen.dart';
import 'package:fmfu/view/screens/fup_simulator_screen.dart';
import 'package:fmfu/view/screens/fupf_screen.dart';
import 'package:fmfu/view/screens/home_screen.dart';
import 'package:fmfu/view/screens/landing_screen.dart';
import 'package:fmfu/view/screens/login_screen.dart';

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
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/assignments',
      page: AssignmentListScreen,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/assignments/:id',
      page: AssignmentDetailScreen,
      guards: [AuthGuard],
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
      path: '/editor/:templateIndex',
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

    AutoRoute(
      path: '/exercises/individual',
      page: ExerciseScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/programs',
      page: EducationProgramListScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/program/:programId',
      page: EducationProgramCrudScreen,
    ),

    AutoRoute(
      path: '/login',
      page: LoginScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/verify-email',
      page: EmailVerifyScreen,
    ),

    // redirect all other paths
    RedirectRoute(path: '*', redirectTo: '/'),
    //Home
  ],
)
class $AppRouter {}