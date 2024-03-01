import 'package:flutter/material.dart';
import 'package:fmfu/utils/screen_widget.dart';
import 'package:fmfu/widgets/fup_form_widget.dart';

class FupFormScreen extends ScreenWidget {
  static const String routeName = "fupf";

  FupFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logScreenView("FupFormScreen");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up Form"),
      ),
      body: const SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FollowUpFormWidget(),
        ),
      ),
    );
  }
}

