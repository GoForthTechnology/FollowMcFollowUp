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
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;
import 'package:flutter/widgets.dart' as _i14;
import 'package:fmfu/auth.dart' as _i13;
import 'package:fmfu/model/chart.dart' as _i16;
import 'package:fmfu/model/exercise.dart' as _i15;
import 'package:fmfu/view/screens/chart_correction_screen.dart' as _i6;
import 'package:fmfu/view/screens/chart_editor_screen.dart' as _i5;
import 'package:fmfu/view/screens/email_verify_screen.dart' as _i10;
import 'package:fmfu/view/screens/exercise_list_screen.dart' as _i8;
import 'package:fmfu/view/screens/fup_simulator_screen.dart' as _i4;
import 'package:fmfu/view/screens/fupf_screen.dart' as _i3;
import 'package:fmfu/view/screens/home_screen.dart' as _i2;
import 'package:fmfu/view/screens/landing_screen.dart' as _i1;
import 'package:fmfu/view/screens/list_programs_screen.dart' as _i7;
import 'package:fmfu/view/screens/login_screen.dart' as _i9;

class AppRouter extends _i11.RootStackRouter {
  AppRouter({
    _i12.GlobalKey<_i12.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i13.AuthGuard authGuard;

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    LandingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LandingScreenRouteArgs>(
          orElse: () => const LandingScreenRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i1.LandingScreen(key: args.key),
      );
    },
    HomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HomeScreenRouteArgs>(
          orElse: () => const HomeScreenRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.HomeScreen(key: args.key),
      );
    },
    FupFormScreenRoute.name: (routeData) {
      final args = routeData.argsAs<FupFormScreenRouteArgs>(
          orElse: () => const FupFormScreenRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.FupFormScreen(key: args.key),
      );
    },
    FollowUpSimulatorPageRoute.name: (routeData) {
      final args = routeData.argsAs<FollowUpSimulatorPageRouteArgs>();
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.FollowUpSimulatorPage(
          key: args.key,
          exerciseState: args.exerciseState,
        ),
      );
    },
    ChartEditorPageRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ChartEditorPage(),
      );
    },
    ChartCorrectingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ChartCorrectingScreenRouteArgs>();
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.ChartCorrectingScreen(
          key: args.key,
          cycle: args.cycle,
        ),
      );
    },
    ListProgramsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ListProgramsScreenRouteArgs>(
          orElse: () => const ListProgramsScreenRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.ListProgramsScreen(key: args.key),
      );
    },
    StaticExerciseListScreenRoute.name: (routeData) {
      final args = routeData.argsAs<StaticExerciseListScreenRouteArgs>(
          orElse: () => const StaticExerciseListScreenRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.StaticExerciseListScreen(key: args.key),
      );
    },
    DynamicExerciseListScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DynamicExerciseListScreenRouteArgs>(
          orElse: () => const DynamicExerciseListScreenRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.DynamicExerciseListScreen(key: args.key),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.LoginScreen(),
      );
    },
    EmailVerifyScreenRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.EmailVerifyScreen(),
      );
    },
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(
          LandingScreenRoute.name,
          path: '/',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LandingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          HomeScreenRoute.name,
          path: '/home',
          guards: [authGuard],
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: HomeScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          FupFormScreenRoute.name,
          path: '/followup_form',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FupFormScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          FollowUpSimulatorPageRoute.name,
          path: '/simulator',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FollowUpSimulatorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          ChartEditorPageRoute.name,
          path: '/editor',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartEditorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          ChartCorrectingScreenRoute.name,
          path: '/correction',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartCorrectingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          ListProgramsScreenRoute.name,
          path: '/programs',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ListProgramsScreenRoute.name,
              redirectTo: '/programs',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          StaticExerciseListScreenRoute.name,
          path: '/exercises/static',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: StaticExerciseListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          DynamicExerciseListScreenRoute.name,
          path: '/exercises/dynamic',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: DynamicExerciseListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          LoginScreenRoute.name,
          path: '/login',
          children: [
            _i11.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LoginScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i11.RouteConfig(
          EmailVerifyScreenRoute.name,
          path: '/verify-email',
        ),
        _i11.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LandingScreen]
class LandingScreenRoute extends _i11.PageRouteInfo<LandingScreenRouteArgs> {
  LandingScreenRoute({
    _i14.Key? key,
    List<_i11.PageRouteInfo>? children,
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

  final _i14.Key? key;

  @override
  String toString() {
    return 'LandingScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeScreenRoute extends _i11.PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    _i14.Key? key,
    List<_i11.PageRouteInfo>? children,
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

  final _i14.Key? key;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.FupFormScreen]
class FupFormScreenRoute extends _i11.PageRouteInfo<FupFormScreenRouteArgs> {
  FupFormScreenRoute({
    _i14.Key? key,
    List<_i11.PageRouteInfo>? children,
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

  final _i14.Key? key;

  @override
  String toString() {
    return 'FupFormScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.FollowUpSimulatorPage]
class FollowUpSimulatorPageRoute
    extends _i11.PageRouteInfo<FollowUpSimulatorPageRouteArgs> {
  FollowUpSimulatorPageRoute({
    _i14.Key? key,
    required _i15.ExerciseState exerciseState,
    List<_i11.PageRouteInfo>? children,
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

  final _i14.Key? key;

  final _i15.ExerciseState exerciseState;

  @override
  String toString() {
    return 'FollowUpSimulatorPageRouteArgs{key: $key, exerciseState: $exerciseState}';
  }
}

/// generated route for
/// [_i5.ChartEditorPage]
class ChartEditorPageRoute extends _i11.PageRouteInfo<void> {
  const ChartEditorPageRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ChartEditorPageRoute.name,
          path: '/editor',
          initialChildren: children,
        );

  static const String name = 'ChartEditorPageRoute';
}

/// generated route for
/// [_i6.ChartCorrectingScreen]
class ChartCorrectingScreenRoute
    extends _i11.PageRouteInfo<ChartCorrectingScreenRouteArgs> {
  ChartCorrectingScreenRoute({
    _i14.Key? key,
    required _i16.Cycle? cycle,
    List<_i11.PageRouteInfo>? children,
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

  final _i14.Key? key;

  final _i16.Cycle? cycle;

  @override
  String toString() {
    return 'ChartCorrectingScreenRouteArgs{key: $key, cycle: $cycle}';
  }
}

/// generated route for
/// [_i7.ListProgramsScreen]
class ListProgramsScreenRoute
    extends _i11.PageRouteInfo<ListProgramsScreenRouteArgs> {
  ListProgramsScreenRoute({
    _i14.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          ListProgramsScreenRoute.name,
          path: '/programs',
          args: ListProgramsScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ListProgramsScreenRoute';
}

class ListProgramsScreenRouteArgs {
  const ListProgramsScreenRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'ListProgramsScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.StaticExerciseListScreen]
class StaticExerciseListScreenRoute
    extends _i11.PageRouteInfo<StaticExerciseListScreenRouteArgs> {
  StaticExerciseListScreenRoute({
    _i14.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          StaticExerciseListScreenRoute.name,
          path: '/exercises/static',
          args: StaticExerciseListScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'StaticExerciseListScreenRoute';
}

class StaticExerciseListScreenRouteArgs {
  const StaticExerciseListScreenRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'StaticExerciseListScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.DynamicExerciseListScreen]
class DynamicExerciseListScreenRoute
    extends _i11.PageRouteInfo<DynamicExerciseListScreenRouteArgs> {
  DynamicExerciseListScreenRoute({
    _i14.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          DynamicExerciseListScreenRoute.name,
          path: '/exercises/dynamic',
          args: DynamicExerciseListScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'DynamicExerciseListScreenRoute';
}

class DynamicExerciseListScreenRouteArgs {
  const DynamicExerciseListScreenRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'DynamicExerciseListScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.LoginScreen]
class LoginScreenRoute extends _i11.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i11.PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          path: '/login',
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [_i10.EmailVerifyScreen]
class EmailVerifyScreenRoute extends _i11.PageRouteInfo<void> {
  const EmailVerifyScreenRoute()
      : super(
          EmailVerifyScreenRoute.name,
          path: '/verify-email',
        );

  static const String name = 'EmailVerifyScreenRoute';
}
