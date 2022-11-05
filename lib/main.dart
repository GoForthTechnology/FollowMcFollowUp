import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:fmfu/view_model/exercise_view_model.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:fmfu/view_model/fup_simulator_view_model.dart';
import 'package:fmfu/view_model/program_list_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

import 'routes.gr.dart';
import 'firebase_options.dart';

Future<void> main() async {
  Loggy.initLoggy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

final _appRouter = AppRouter();

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ChartCorrectionViewModel()),
        ChangeNotifierProvider.value(value: ChartListViewModel()),
        ChangeNotifierProvider.value(value: FollowUpFormViewModel()),
        ChangeNotifierProvider.value(value: FollowUpSimulatorViewModel()),
        ChangeNotifierProvider.value(value: ExerciseViewModel()),
        ChangeNotifierProvider.value(value: ExerciseListViewModel()),
        ChangeNotifierProvider.value(value: ProgramListViewModel()),
      ], child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Follow McFollowUp',
      theme: ThemeData(
        textTheme: GoogleFonts.sourceSans3TextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    ));
  }
}
