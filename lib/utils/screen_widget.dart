
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

abstract class ScreenWidget extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  ScreenWidget({super.key});

  void logScreenView(String screenClass) {
    analytics.logScreenView(screenClass: screenClass);
  }
}