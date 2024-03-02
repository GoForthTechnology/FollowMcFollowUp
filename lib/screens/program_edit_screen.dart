import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/api/education_program_service.dart';
import 'package:fmfu/model/education_program.dart';
import 'package:fmfu/utils/navigation_rail_screen.dart';
import 'package:fmfu/widgets/info_panel.dart';
import 'package:provider/provider.dart';

class ProgramEditScreen extends StatelessWidget {
  final String programID;

  const ProgramEditScreen({super.key, @pathParam required this.programID});
  
  @override
  Widget build(BuildContext context) {
    return NavigationRailScreen(
      title: const Text("Education Programs"),
      item: NavigationItem.programs,
      content: _content(context),
      fab: FloatingActionButton(
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _content(BuildContext context) {
    return Consumer<EducationProgramService>(builder: (context, service, child) => StreamBuilder<List<EducationProgram>?>(
      stream: service.streamAll(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var programs = snapshot.data ?? [];
        var tiles = programs.map((p) => ExpandableInfoPanel(
          title: p.name,
          subtitle: "",
          contents: const [],
        )).toList();
        return SingleChildScrollView(child: Column(children: tiles));
      },
    ));
  }
}