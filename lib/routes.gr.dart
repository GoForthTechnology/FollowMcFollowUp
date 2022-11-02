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
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:fmfu/model/chart.dart' as _i10;
import 'package:fmfu/model/exercise.dart' as _i9;
import 'package:fmfu/view/screens/chart_correction_screen.dart' as _i6;
import 'package:fmfu/view/screens/chart_editor_screen.dart' as _i5;
import 'package:fmfu/view/screens/fup_simulator_screen.dart' as _i4;
import 'package:fmfu/view/screens/fupf_screen.dart' as _i3;
import 'package:fmfu/view/screens/home_screen.dart' as _i2;
import 'package:fmfu/view/screens/landing_screen.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    LandingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LandingScreenRouteArgs>(
          orElse: () => const LandingScreenRouteArgs());
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i1.LandingScreen(key: args.key),
      );
    },
    HomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HomeScreenRouteArgs>(
          orElse: () => const HomeScreenRouteArgs());
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.HomeScreen(key: args.key),
      );
    },
    FupFormScreenRoute.name: (routeData) {
      final args = routeData.argsAs<FupFormScreenRouteArgs>(
          orElse: () => const FupFormScreenRouteArgs());
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.FupFormScreen(key: args.key),
      );
    },
    FollowUpSimulatorPageRoute.name: (routeData) {
      final args = routeData.argsAs<FollowUpSimulatorPageRouteArgs>();
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.FollowUpSimulatorPage(
          key: args.key,
          exerciseState: args.exerciseState,
        ),
      );
    },
    ChartEditorPageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ChartEditorPage(),
      );
    },
    ChartCorrectingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ChartCorrectingScreenRouteArgs>();
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.ChartCorrectingScreen(
          key: args.key,
          cycle: args.cycle,
        ),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          LandingScreenRoute.name,
          path: '/',
          children: [
            _i7.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LandingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i7.RouteConfig(
          HomeScreenRoute.name,
          path: '/home',
          children: [
            _i7.RouteConfig(
              '*#redirect',
              path: '*',
              parent: HomeScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i7.RouteConfig(
          FupFormScreenRoute.name,
          path: '/followup_form',
          children: [
            _i7.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FupFormScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i7.RouteConfig(
          FollowUpSimulatorPageRoute.name,
          path: '/simulator',
          children: [
            _i7.RouteConfig(
              '*#redirect',
              path: '*',
              parent: FollowUpSimulatorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i7.RouteConfig(
          ChartEditorPageRoute.name,
          path: '/editor',
          children: [
            _i7.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartEditorPageRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i7.RouteConfig(
          ChartCorrectingScreenRoute.name,
          path: '/correction',
          children: [
            _i7.RouteConfig(
              '*#redirect',
              path: '*',
              parent: ChartCorrectingScreenRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i7.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LandingScreen]
class LandingScreenRoute extends _i7.PageRouteInfo<LandingScreenRouteArgs> {
  LandingScreenRoute({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
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

  final _i8.Key? key;

  @override
  String toString() {
    return 'LandingScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeScreenRoute extends _i7.PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
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

  final _i8.Key? key;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.FupFormScreen]
class FupFormScreenRoute extends _i7.PageRouteInfo<FupFormScreenRouteArgs> {
  FupFormScreenRoute({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
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

  final _i8.Key? key;

  @override
  String toString() {
    return 'FupFormScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.FollowUpSimulatorPage]
class FollowUpSimulatorPageRoute
    extends _i7.PageRouteInfo<FollowUpSimulatorPageRouteArgs> {
  FollowUpSimulatorPageRoute({
    _i8.Key? key,
    required _i9.ExerciseState exerciseState,
    List<_i7.PageRouteInfo>? children,
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

  final _i8.Key? key;

  final _i9.ExerciseState exerciseState;

  @override
  String toString() {
    return 'FollowUpSimulatorPageRouteArgs{key: $key, exerciseState: $exerciseState}';
  }
}

/// generated route for
/// [_i5.ChartEditorPage]
class ChartEditorPageRoute extends _i7.PageRouteInfo<void> {
  const ChartEditorPageRoute({List<_i7.PageRouteInfo>? children})
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
    extends _i7.PageRouteInfo<ChartCorrectingScreenRouteArgs> {
  ChartCorrectingScreenRoute({
    _i8.Key? key,
    required _i10.Cycle? cycle,
    List<_i7.PageRouteInfo>? children,
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

  final _i8.Key? key;

  final _i10.Cycle? cycle;

  @override
  String toString() {
    return 'ChartCorrectingScreenRouteArgs{key: $key, cycle: $cycle}';
  }
}
