import 'package:flutter/material.dart';
import 'package:fmfu/view/widgets/fup_form_widget.dart';

class FupFormScreen extends StatelessWidget {
  static const String routeName = "fupf";

  const FupFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

