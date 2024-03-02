import 'package:auto_route/auto_route.dart';
import 'package:fmfu/auth.dart';
import 'package:fmfu/screens/assignment_detail_screen.dart';
import 'package:fmfu/screens/assignment_list_screen.dart';
import 'package:fmfu/screens/chart_correction_screen.dart';
import 'package:fmfu/screens/chart_editor_screen.dart';
import 'package:fmfu/screens/drills_screen.dart';
import 'package:fmfu/screens/education_program_crud_screen.dart';
import 'package:fmfu/screens/email_verify_screen.dart';
import 'package:fmfu/screens/exercise_list_screen.dart';
import 'package:fmfu/screens/fup_simulator_screen.dart';
import 'package:fmfu/screens/fupf_screen.dart';
import 'package:fmfu/screens/home_screen.dart';
import 'package:fmfu/screens/login_screen.dart';
import 'package:fmfu/screens/program_list_screen.dart';
import 'package:fmfu/screens/signup_screen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
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
      path: '/drills',
      page: DrillsScreen,
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
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/simulator',
      page: FollowUpSimulatorPage,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/editor/:templateIndex',
      page: ChartEditorPage,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/correction',
      page: ChartCorrectingScreen,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/exercises/individual',
      page: ExerciseScreen,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/programs',
      page: ProgramListScreen,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/program/:programId',
      page: EducationProgramCrudScreen,
      guards: [AuthGuard],
    ),

    AutoRoute(
      path: '/login',
      page: LoginScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),

    AutoRoute(
      path: '/signup/:programID',
      page: SignupScreen,
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