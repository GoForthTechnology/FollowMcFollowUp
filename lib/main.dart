import 'package:flutter/material.dart';
import 'package:fmfu/view/screens/chart_correction_screen.dart';
import 'package:fmfu/view/screens/chart_editor_screen.dart';
import 'package:fmfu/view/screens/fupf_screen.dart';
import 'package:fmfu/view/screens/home_screen.dart';
import 'package:fmfu/view/screens/landing_screen.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:fmfu/view_model/exercise_view_model.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:fmfu/view_model/fup_simulator_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

void main() {
  Loggy.initLoggy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ChartCorrectionViewModel()),
        ChangeNotifierProvider.value(value: ChartListViewModel()),
        ChangeNotifierProvider.value(value: FollowUpFormViewModel()),
        ChangeNotifierProvider.value(value: FollowUpSimulatorViewModel()),
        ChangeNotifierProvider.value(value: ExerciseViewModel()),
      ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Follow McFollowUp',
      theme: ThemeData(
        textTheme: GoogleFonts.sourceSans3TextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: const LandingScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        ChartEditorPage.routeName: (context) => const ChartEditorPage(),
        FupFormScreen.routeName: (context) => const FupFormScreen(),
        ChartCorrectingScreen.routeName: (context) => const ChartCorrectingScreen(cycle: null,),
      },
      ));
  }
}
