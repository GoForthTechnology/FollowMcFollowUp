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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:fmfu/model/chart.dart' as _i12;
import 'package:fmfu/model/exercise.dart' as _i11;
import 'package:fmfu/view/screens/chart_correction_screen.dart' as _i6;
import 'package:fmfu/view/screens/chart_editor_screen.dart' as _i5;
import 'package:fmfu/view/screens/exercise_list_screen.dart' as _i8;
import 'package:fmfu/view/screens/fup_simulator_screen.dart' as _i4;
import 'package:fmfu/view/screens/fupf_screen.dart' as _i3;
import 'package:fmfu/view/screens/home_screen.dart' as _i2;
import 'package:fmfu/view/screens/landing_screen.dart' as _i1;
import 'package:fmfu/view/screens/list_programs_screen.dart' as _i7;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    LandingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LandingScreenRouteArgs>(
          orElse: () => const LandingScreenRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i1.LandingScreen(key: args.key),
      );
    },
    HomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HomeScreenRouteArgs>(
          orElse: () => const HomeScreenRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.HomeScreen(key: args.key),
      );
    },
    FupFormScreenRoute.name: (routeData) {
      final args = routeData.argsAs<FupFormScreenRouteArgs>(
          orElse: () => const FupFormScreenRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.FupFormScreen(key: args.key),
      );
    },
    FollowUpSimulatorPageRoute.name: (routeData) {
      final args = routeData.argsAs<FollowUpSimulatorPageRouteArgs>();
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.FollowUpSimulatorPage(
          key: args.key,
          exerciseState: args.exerciseState,
        ),
      );
    },
    ChartEditorPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ChartEditorPage(),
      );
    },
    ChartCorrectingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ChartCorrectingScreenRouteArgs>();
      return _i9.AdaptivePage<dynamic>(
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
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.ListProgramsScreen(key: args.key),
      );
    },
    StaticExerciseListScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.StaticExerciseListScreen(),
      );
    },
    DynamicExerciseListScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DynamicExerciseListScreenRouteArgs>(
          orElse: () => const DynamicExerciseListScreenRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.DynamicExerciseListScreen(key: args.key),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          LandingScreenRoute.name,
          path: '/',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LandingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          HomeScreenRoute.name,
          path: '/home',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: HomeScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          FupFormScreenRoute.name,
          path: '/followup_form',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FupFormScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          FollowUpSimulatorPageRoute.name,
          path: '/simulator',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FollowUpSimulatorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          ChartEditorPageRoute.name,
          path: '/editor',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartEditorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          ChartCorrectingScreenRoute.name,
          path: '/correction',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartCorrectingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          ListProgramsScreenRoute.name,
          path: '/programs',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ListProgramsScreenRoute.name,
              redirectTo: '/programs',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          StaticExerciseListScreenRoute.name,
          path: '/exercises/static',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: StaticExerciseListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          DynamicExerciseListScreenRoute.name,
          path: '/exercises/dynamic',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: DynamicExerciseListScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LandingScreen]
class LandingScreenRoute extends _i9.PageRouteInfo<LandingScreenRouteArgs> {
  LandingScreenRoute({
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'LandingScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeScreenRoute extends _i9.PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.FupFormScreen]
class FupFormScreenRoute extends _i9.PageRouteInfo<FupFormScreenRouteArgs> {
  FupFormScreenRoute({
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'FupFormScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.FollowUpSimulatorPage]
class FollowUpSimulatorPageRoute
    extends _i9.PageRouteInfo<FollowUpSimulatorPageRouteArgs> {
  FollowUpSimulatorPageRoute({
    _i10.Key? key,
    required _i11.ExerciseState exerciseState,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  final _i11.ExerciseState exerciseState;

  @override
  String toString() {
    return 'FollowUpSimulatorPageRouteArgs{key: $key, exerciseState: $exerciseState}';
  }
}

/// generated route for
/// [_i5.ChartEditorPage]
class ChartEditorPageRoute extends _i9.PageRouteInfo<void> {
  const ChartEditorPageRoute({List<_i9.PageRouteInfo>? children})
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
    extends _i9.PageRouteInfo<ChartCorrectingScreenRouteArgs> {
  ChartCorrectingScreenRoute({
    _i10.Key? key,
    required _i12.Cycle? cycle,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  final _i12.Cycle? cycle;

  @override
  String toString() {
    return 'ChartCorrectingScreenRouteArgs{key: $key, cycle: $cycle}';
  }
}

/// generated route for
/// [_i7.ListProgramsScreen]
class ListProgramsScreenRoute
    extends _i9.PageRouteInfo<ListProgramsScreenRouteArgs> {
  ListProgramsScreenRoute({
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'ListProgramsScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.StaticExerciseListScreen]
class StaticExerciseListScreenRoute extends _i9.PageRouteInfo<void> {
  const StaticExerciseListScreenRoute({List<_i9.PageRouteInfo>? children})
      : super(
          StaticExerciseListScreenRoute.name,
          path: '/exercises/static',
          initialChildren: children,
        );

  static const String name = 'StaticExerciseListScreenRoute';
}

/// generated route for
/// [_i8.DynamicExerciseListScreen]
class DynamicExerciseListScreenRoute
    extends _i9.PageRouteInfo<DynamicExerciseListScreenRouteArgs> {
  DynamicExerciseListScreenRoute({
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
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

  final _i10.Key? key;

  @override
  String toString() {
    return 'DynamicExerciseListScreenRouteArgs{key: $key}';
  }
}
