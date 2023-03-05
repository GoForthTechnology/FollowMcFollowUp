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
import 'package:fmfu/view/screens/assignment_detail_screen.dart' as _i4;
import 'package:fmfu/view/screens/assignment_list_screen.dart' as _i3;
import 'package:fmfu/view/screens/chart_correction_screen.dart' as _i8;
import 'package:fmfu/view/screens/chart_editor_screen.dart' as _i7;
import 'package:fmfu/view/screens/education_program_crud_screen.dart' as _i11;
import 'package:fmfu/view/screens/education_program_list_screen.dart' as _i10;
import 'package:fmfu/view/screens/email_verify_screen.dart' as _i13;
import 'package:fmfu/view/screens/exercise_list_screen.dart' as _i9;
import 'package:fmfu/view/screens/fup_simulator_screen.dart' as _i6;
import 'package:fmfu/view/screens/fupf_screen.dart' as _i5;
import 'package:fmfu/view/screens/home_screen.dart' as _i2;
import 'package:fmfu/view/screens/landing_screen.dart' as _i1;
import 'package:fmfu/view/screens/login_screen.dart' as _i12;

class AppRouter extends _i14.RootStackRouter {
  AppRouter({
    _i15.GlobalKey<_i15.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i16.AuthGuard authGuard;

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    LandingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LandingScreenRouteArgs>(
          orElse: () => const LandingScreenRouteArgs());
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i1.LandingScreen(key: args.key),
      );
    },
    HomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HomeScreenRouteArgs>(
          orElse: () => const HomeScreenRouteArgs());
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.HomeScreen(key: args.key),
      );
    },
    AssignmentListScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.AssignmentListScreen(),
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
        ),
      );
    },
    ExerciseScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.ExerciseScreen(),
      );
    },
    EducationProgramListScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.EducationProgramListScreen(),
      );
    },
    EducationProgramCrudScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EducationProgramCrudScreenRouteArgs>(
          orElse: () => EducationProgramCrudScreenRouteArgs(
              programId: pathParams.optString('programId')));
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i11.EducationProgramCrudScreen(
          key: args.key,
          programId: args.programId,
        ),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i12.LoginScreen(),
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
          LandingScreenRoute.name,
          path: '/',
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LandingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
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
          ExerciseScreenRoute.name,
          path: '/exercises/individual',
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ExerciseScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          EducationProgramListScreenRoute.name,
          path: '/programs',
          children: [
            _i14.RouteConfig(
              '*#redirect',
              path: '*',
              parent: EducationProgramListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i14.RouteConfig(
          EducationProgramCrudScreenRoute.name,
          path: '/program/:programId',
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
/// [_i1.LandingScreen]
class LandingScreenRoute extends _i14.PageRouteInfo<LandingScreenRouteArgs> {
  LandingScreenRoute({
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          LandingScreenRoute.name,
          path: '/',
          args: LandingScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LandingScreenRoute';
}

class LandingScreenRouteArgs {
  const LandingScreenRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'LandingScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeScreenRoute extends _i14.PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          HomeScreenRoute.name,
          path: '/home',
          args: HomeScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';
}

class HomeScreenRouteArgs {
  const HomeScreenRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.AssignmentListScreen]
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
    List<_i14.PageRouteInfo>? children,
  }) : super(
          FollowUpSimulatorPageRoute.name,
          path: '/simulator',
          args: FollowUpSimulatorPageRouteArgs(
            key: key,
            exerciseState: exerciseState,
          ),
          initialChildren: children,
        );

  static const String name = 'FollowUpSimulatorPageRoute';
}

class FollowUpSimulatorPageRouteArgs {
  const FollowUpSimulatorPageRouteArgs({
    this.key,
    required this.exerciseState,
  });

  final _i15.Key? key;

  final _i18.ExerciseState exerciseState;

  @override
  String toString() {
    return 'FollowUpSimulatorPageRouteArgs{key: $key, exerciseState: $exerciseState}';
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
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ChartCorrectingScreenRoute.name,
          path: '/correction',
          args: ChartCorrectingScreenRouteArgs(
            key: key,
            cycle: cycle,
          ),
          initialChildren: children,
        );

  static const String name = 'ChartCorrectingScreenRoute';
}

class ChartCorrectingScreenRouteArgs {
  const ChartCorrectingScreenRouteArgs({
    this.key,
    required this.cycle,
  });

  final _i15.Key? key;

  final _i19.Cycle? cycle;

  @override
  String toString() {
    return 'ChartCorrectingScreenRouteArgs{key: $key, cycle: $cycle}';
  }
}

/// generated route for
/// [_i9.ExerciseScreen]
class ExerciseScreenRoute extends _i14.PageRouteInfo<void> {
  const ExerciseScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ExerciseScreenRoute.name,
          path: '/exercises/individual',
          initialChildren: children,
        );

  static const String name = 'ExerciseScreenRoute';
}

/// generated route for
/// [_i10.EducationProgramListScreen]
class EducationProgramListScreenRoute extends _i14.PageRouteInfo<void> {
  const EducationProgramListScreenRoute({List<_i14.PageRouteInfo>? children})
      : super(
          EducationProgramListScreenRoute.name,
          path: '/programs',
          initialChildren: children,
        );

  static const String name = 'EducationProgramListScreenRoute';
}

/// generated route for
/// [_i11.EducationProgramCrudScreen]
class EducationProgramCrudScreenRoute
    extends _i14.PageRouteInfo<EducationProgramCrudScreenRouteArgs> {
  EducationProgramCrudScreenRoute({
    _i15.Key? key,
    String? programId,
  }) : super(
          EducationProgramCrudScreenRoute.name,
          path: '/program/:programId',
          args: EducationProgramCrudScreenRouteArgs(
            key: key,
            programId: programId,
          ),
          rawPathParams: {'programId': programId},
        );

  static const String name = 'EducationProgramCrudScreenRoute';
}

class EducationProgramCrudScreenRouteArgs {
  const EducationProgramCrudScreenRouteArgs({
    this.key,
    this.programId,
  });

  final _i15.Key? key;

  final String? programId;

  @override
  String toString() {
    return 'EducationProgramCrudScreenRouteArgs{key: $key, programId: $programId}';
  }
}

/// generated route for
/// [_i12.LoginScreen]
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
/// [_i13.EmailVerifyScreen]
class EmailVerifyScreenRoute extends _i14.PageRouteInfo<void> {
  const EmailVerifyScreenRoute()
      : super(
          EmailVerifyScreenRoute.name,
          path: '/verify-email',
        );

  static const String name = 'EmailVerifyScreenRoute';
}
