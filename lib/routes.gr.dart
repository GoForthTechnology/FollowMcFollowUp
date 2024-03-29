// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;
import 'package:fmfu/auth.dart' as _i16;
import 'package:fmfu/model/assignment.dart' as _i17;
import 'package:fmfu/model/chart.dart' as _i19;
import 'package:fmfu/model/exercise.dart' as _i18;
import 'package:fmfu/screens/assignment_detail_screen.dart' as _i4;
import 'package:fmfu/screens/assignment_list_screen.dart' as _i2;
import 'package:fmfu/screens/chart_correction_screen.dart' as _i8;
import 'package:fmfu/screens/chart_editor_screen.dart' as _i7;
import 'package:fmfu/screens/drills_screen.dart' as _i3;
import 'package:fmfu/screens/email_verify_screen.dart' as _i13;
import 'package:fmfu/screens/fup_simulator_screen.dart' as _i6;
import 'package:fmfu/screens/fupf_screen.dart' as _i5;
import 'package:fmfu/screens/home_screen.dart' as _i1;
import 'package:fmfu/screens/login_screen.dart' as _i11;
import 'package:fmfu/screens/program_edit_screen.dart' as _i10;
import 'package:fmfu/screens/program_list_screen.dart' as _i9;
import 'package:fmfu/screens/signup_screen.dart' as _i12;

class AppRouter extends _i14.RootStackRouter {
  AppRouter({
    _i15.GlobalKey<_i15.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i16.AuthGuard authGuard;

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    HomeScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    AssignmentListScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.AssignmentListScreen(),
      );
    },
    DrillsScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.DrillsScreen(),
      );
    },
    AssignmentDetailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AssignmentDetailScreenRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.AssignmentDetailScreen(
          key: args.key,
          id: args.id,
          assignment: args.assignment,
        ),
      );
    },
    FupFormScreenRoute.name: (routeData) {
      final args = routeData.argsAs<FupFormScreenRouteArgs>(
          orElse: () => const FupFormScreenRouteArgs());
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.FupFormScreen(key: args.key),
      );
    },
    FollowUpSimulatorPageRoute.name: (routeData) {
      final args = routeData.argsAs<FollowUpSimulatorPageRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.FollowUpSimulatorPage(
          key: args.key,
          exerciseState: args.exerciseState,
          exerciseName: args.exerciseName,
        ),
      );
    },
    ChartEditorPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChartEditorPageRouteArgs>(
          orElse: () => ChartEditorPageRouteArgs(
              templateIndex: pathParams.getInt('templateIndex')));
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.ChartEditorPage(
          key: args.key,
          templateIndex: args.templateIndex,
        ),
      );
    },
    ChartCorrectingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ChartCorrectingScreenRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.ChartCorrectingScreen(
          key: args.key,
          cycle: args.cycle,
          exerciseName: args.exerciseName,
        ),
      );
    },
    ProgramListScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.ProgramListScreen(),
      );
    },
    ProgramEditScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProgramEditScreenRouteArgs>(
          orElse: () => ProgramEditScreenRouteArgs(
              programID: pathParams.getString('programID')));
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i10.ProgramEditScreen(
          key: args.key,
          programID: args.programID,
        ),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i11.LoginScreen(),
      );
    },
    SignupScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SignupScreenRouteArgs>(
          orElse: () => SignupScreenRouteArgs(
              programID: pathParams.getString('programID')));
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i12.SignupScreen(
          key: args.key,
          programID: args.programID,
        ),
      );
    },
    EmailVerifyScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i13.EmailVerifyScreen(),
      );
    },
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/home',
          fullMatch: true,
        ),
        _i14.RouteConfig(
          HomeScreenRoute.name,
          path: '/home',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: HomeScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          AssignmentListScreenRoute.name,
          path: '/assignments',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: AssignmentListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          DrillsScreenRoute.name,
          path: '/drills',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: DrillsScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          AssignmentDetailScreenRoute.name,
          path: '/assignments/:id',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: AssignmentDetailScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          FupFormScreenRoute.name,
          path: '/followup_form',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FupFormScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          FollowUpSimulatorPageRoute.name,
          path: '/simulator',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FollowUpSimulatorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          ChartEditorPageRoute.name,
          path: '/editor/:templateIndex',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartEditorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          ChartCorrectingScreenRoute.name,
          path: '/correction',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartCorrectingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          ProgramListScreenRoute.name,
          path: '/programs',
          guards: [authGuard],
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ProgramListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          ProgramEditScreenRoute.name,
          path: '/program/:programID',
          guards: [authGuard],
        ),
        _i14.RouteConfig(
          LoginScreenRoute.name,
          path: '/login',
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LoginScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          SignupScreenRoute.name,
          path: '/signup/:programID',
        ),
        _i14.RouteConfig(
          EmailVerifyScreenRoute.name,
          path: '/verify-email',
        ),
        _i14.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeScreenRoute extends _i14.PageRouteInfo<void> {
  const HomeScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [_i2.AssignmentListScreen]
class AssignmentListScreenRoute extends _i14.PageRouteInfo<void> {
  const AssignmentListScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          AssignmentListScreenRoute.name,
          path: '/assignments',
          initialChildren: children,
        );

  static const String name = 'AssignmentListScreenRoute';
}

/// generated route for
/// [_i3.DrillsScreen]
class DrillsScreenRoute extends _i14.PageRouteInfo<void> {
  const DrillsScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          DrillsScreenRoute.name,
          path: '/drills',
          initialChildren: children,
        );

  static const String name = 'DrillsScreenRoute';
}

/// generated route for
/// [_i4.AssignmentDetailScreen]
class AssignmentDetailScreenRoute
    extends _i14.PageRouteInfo<AssignmentDetailScreenRouteArgs> {
  AssignmentDetailScreenRoute({
    _i15.Key? key,
    required int id,
    required _i17.PreClientAssignment assignment,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          AssignmentDetailScreenRoute.name,
          path: '/assignments/:id',
          args: AssignmentDetailScreenRouteArgs(
            key: key,
            id: id,
            assignment: assignment,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'AssignmentDetailScreenRoute';
}

class AssignmentDetailScreenRouteArgs {
  const AssignmentDetailScreenRouteArgs({
    this.key,
    required this.id,
    required this.assignment,
  });

  final _i15.Key? key;

  final int id;

  final _i17.PreClientAssignment assignment;

  @override
  String toString() {
    return 'AssignmentDetailScreenRouteArgs{key: $key, id: $id, assignment: $assignment}';
  }
}

/// generated route for
/// [_i5.FupFormScreen]
class FupFormScreenRoute extends _i14.PageRouteInfo<FupFormScreenRouteArgs> {
  FupFormScreenRoute({
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          FupFormScreenRoute.name,
          path: '/followup_form',
          args: FupFormScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'FupFormScreenRoute';
}

class FupFormScreenRouteArgs {
  const FupFormScreenRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'FupFormScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.FollowUpSimulatorPage]
class FollowUpSimulatorPageRoute
    extends _i14.PageRouteInfo<FollowUpSimulatorPageRouteArgs> {
  FollowUpSimulatorPageRoute({
    _i15.Key? key,
    required _i18.ExerciseState exerciseState,
    required String exerciseName,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          FollowUpSimulatorPageRoute.name,
          path: '/simulator',
          args: FollowUpSimulatorPageRouteArgs(
            key: key,
            exerciseState: exerciseState,
            exerciseName: exerciseName,
          ),
          initialChildren: children,
        );

  static const String name = 'FollowUpSimulatorPageRoute';
}

class FollowUpSimulatorPageRouteArgs {
  const FollowUpSimulatorPageRouteArgs({
    this.key,
    required this.exerciseState,
    required this.exerciseName,
  });

  final _i15.Key? key;

  final _i18.ExerciseState exerciseState;

  final String exerciseName;

  @override
  String toString() {
    return 'FollowUpSimulatorPageRouteArgs{key: $key, exerciseState: $exerciseState, exerciseName: $exerciseName}';
  }
}

/// generated route for
/// [_i7.ChartEditorPage]
class ChartEditorPageRoute
    extends _i14.PageRouteInfo<ChartEditorPageRouteArgs> {
  ChartEditorPageRoute({
    _i15.Key? key,
    required int templateIndex,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ChartEditorPageRoute.name,
          path: '/editor/:templateIndex',
          args: ChartEditorPageRouteArgs(
            key: key,
            templateIndex: templateIndex,
          ),
          rawPathParams: {'templateIndex': templateIndex},
          initialChildren: children,
        );

  static const String name = 'ChartEditorPageRoute';
}

class ChartEditorPageRouteArgs {
  const ChartEditorPageRouteArgs({
    this.key,
    required this.templateIndex,
  });

  final _i15.Key? key;

  final int templateIndex;

  @override
  String toString() {
    return 'ChartEditorPageRouteArgs{key: $key, templateIndex: $templateIndex}';
  }
}

/// generated route for
/// [_i8.ChartCorrectingScreen]
class ChartCorrectingScreenRoute
    extends _i14.PageRouteInfo<ChartCorrectingScreenRouteArgs> {
  ChartCorrectingScreenRoute({
    _i15.Key? key,
    required _i19.Cycle? cycle,
    required String exerciseName,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ChartCorrectingScreenRoute.name,
          path: '/correction',
          args: ChartCorrectingScreenRouteArgs(
            key: key,
            cycle: cycle,
            exerciseName: exerciseName,
          ),
          initialChildren: children,
        );

  static const String name = 'ChartCorrectingScreenRoute';
}

class ChartCorrectingScreenRouteArgs {
  const ChartCorrectingScreenRouteArgs({
    this.key,
    required this.cycle,
    required this.exerciseName,
  });

  final _i15.Key? key;

  final _i19.Cycle? cycle;

  final String exerciseName;

  @override
  String toString() {
    return 'ChartCorrectingScreenRouteArgs{key: $key, cycle: $cycle, exerciseName: $exerciseName}';
  }
}

/// generated route for
/// [_i9.ProgramListScreen]
class ProgramListScreenRoute extends _i14.PageRouteInfo<void> {
  const ProgramListScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ProgramListScreenRoute.name,
          path: '/programs',
          initialChildren: children,
        );

  static const String name = 'ProgramListScreenRoute';
}

/// generated route for
/// [_i10.ProgramEditScreen]
class ProgramEditScreenRoute
    extends _i14.PageRouteInfo<ProgramEditScreenRouteArgs> {
  ProgramEditScreenRoute({
    _i15.Key? key,
    required String programID,
  }) : super(
          ProgramEditScreenRoute.name,
          path: '/program/:programID',
          args: ProgramEditScreenRouteArgs(
            key: key,
            programID: programID,
          ),
          rawPathParams: {'programID': programID},
        );

  static const String name = 'ProgramEditScreenRoute';
}

class ProgramEditScreenRouteArgs {
  const ProgramEditScreenRouteArgs({
    this.key,
    required this.programID,
  });

  final _i15.Key? key;

  final String programID;

  @override
  String toString() {
    return 'ProgramEditScreenRouteArgs{key: $key, programID: $programID}';
  }
}

/// generated route for
/// [_i11.LoginScreen]
class LoginScreenRoute extends _i14.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          path: '/login',
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [_i12.SignupScreen]
class SignupScreenRoute extends _i14.PageRouteInfo<SignupScreenRouteArgs> {
  SignupScreenRoute({
    _i15.Key? key,
    required String programID,
  }) : super(
          SignupScreenRoute.name,
          path: '/signup/:programID',
          args: SignupScreenRouteArgs(
            key: key,
            programID: programID,
          ),
          rawPathParams: {'programID': programID},
        );

  static const String name = 'SignupScreenRoute';
}

class SignupScreenRouteArgs {
  const SignupScreenRouteArgs({
    this.key,
    required this.programID,
  });

  final _i15.Key? key;

  final String programID;

  @override
  String toString() {
    return 'SignupScreenRouteArgs{key: $key, programID: $programID}';
  }
}

/// generated route for
/// [_i13.EmailVerifyScreen]
class EmailVerifyScreenRoute extends _i14.PageRouteInfo<void> {
  const EmailVerifyScreenRoute()
      : super(
          EmailVerifyScreenRoute.name,
          path: '/verify-email',
        );

  static const String name = 'EmailVerifyScreenRoute';
}
