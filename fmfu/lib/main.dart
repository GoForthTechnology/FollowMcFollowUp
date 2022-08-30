import 'package:flutter/material.dart';
import 'package:fmfu/view/chart_screen.dart';
import 'package:fmfu/view/home_screen.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ChartListViewModel()),
      ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        ChartPage.routeName: (context) => ChartPage(),
      },
      ));
  }
}
