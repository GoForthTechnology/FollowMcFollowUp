import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmfu/api/education_program_service.dart';
import 'package:fmfu/api/enrollment_service.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/model/education_program.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/navigation_rail_screen.dart';
import 'package:fmfu/widgets/info_panel.dart';
import 'package:provider/provider.dart';

class ProgramListScreen extends StatelessWidget {
  const ProgramListScreen({super.key});
  
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
          contents: [
            EnrollmentWidget(program: p),
          ],
        )).toList();
        return SingleChildScrollView(child: Column(children: tiles));
      },
    ));
  }
}

class EnrollmentWidget extends StatefulWidget {
  final EducationProgram program;

  const EnrollmentWidget({super.key, required this.program});


  @override
  State<StatefulWidget> createState() => _EnrollmentWidgetState();
}

class _EnrollmentWidgetState extends State<EnrollmentWidget> {
  bool enrollmentEnabled = true;

  @override
  Widget build(BuildContext context) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    return Consumer<EnrollmentService>(builder: (context, service, child) => Row(children: [
      const Text("Enable Enrollment?"),
      StreamBuilder<bool>(
        stream: service.contains(widget.program.id ?? ""),
        builder: (context, snapshot) => Switch(value: snapshot.data ?? false, onChanged: (v) {
          if (v) {
            service.add(widget.program.id ?? "").then((_) {
              const snackBar = SnackBar(content: Text("Enrollment activated"));
              scaffoldMessenger.showSnackBar(snackBar);
            });
          } else {
            service.remove(widget.program.id ?? "").then((_) {
              const snackBar = SnackBar(content: Text("Enrollment deactivated"));
              scaffoldMessenger.showSnackBar(snackBar);
            });
          }
          setState(() {
            enrollmentEnabled = v;
          });
        },),
      ),
      if (enrollmentEnabled) TextButton(onPressed: () async {
        await Clipboard.setData(ClipboardData(text: _signupLink()));
        const snackBar = SnackBar(content: Text("Link copied to clipboard"));
        scaffoldMessenger.showSnackBar(snackBar);
      }, child: const Text("Copy Invite Link")),
    ],));
  }

  String _signupLink() {
    return "http://${Uri.base.authority}/#/signup/${widget.program.id}";
  }

}

class StampSelectionPanel extends StatelessWidget {
  final List<Exercise> exercises;

  const StampSelectionPanel({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return ExpandableInfoPanel(
      title: "Stamp Selection",
      subtitle: "Select the correct stamp for each day in the cycle",
      contents: exercises.map((exercise) => TextButton(
        onPressed: exercise.enabled ? () {
          AutoRouter.of(context).push(ChartCorrectingScreenRoute(
              cycle: exercise.getState(includeErrorScenarios: false).cycles[1]));
        } : null,
        child: Text(exercise.name),
      )).toList(),
    );
  }
}

class ChartCorrectingPanel extends StatelessWidget {
  final List<Exercise> exercises;

  const ChartCorrectingPanel({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return ExpandableInfoPanel(
      title: "Chart Correcting",
      subtitle: "Find and correct all the errors in the provided chart",
      contents: exercises.map((exercise) => TextButton(
        onPressed: exercise.enabled ? () {
          AutoRouter.of(context).push(FollowUpSimulatorPageRoute(
              exerciseState: exercise.getState(includeErrorScenarios: true)));
        } : null,
        child: Text(exercise.name),
      )).toList(),
    );
  }
}