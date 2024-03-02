import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmfu/api/education_program_service.dart';
import 'package:fmfu/api/enrollment_service.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/education_program.dart';
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
            StudentCountWidget(program: p,),
          ],
        )).toList();
        return SingleChildScrollView(child: Column(children: tiles));
      },
    ));
  }
}

class StudentCountWidget extends StatelessWidget {
  final EducationProgram program;

  const StudentCountWidget({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (context, service, child) => Row(children: [
      StreamBuilder(
        stream: service.getStudents(program),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Text("Num Students: ${snapshot.data?.length ?? 0}");
        },
      ),
    ],),);
  }

}

class EnrollmentWidget extends StatefulWidget {
  final EducationProgram program;

  const EnrollmentWidget({super.key, required this.program});


  @override
  State<StatefulWidget> createState() => _EnrollmentWidgetState();
}

class _EnrollmentWidgetState extends State<EnrollmentWidget> {

  @override
  Widget build(BuildContext context) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    return Consumer<EnrollmentService>(builder: (context, service, child) => StreamBuilder(
      stream: service.contains(widget.program.id ?? ""),
      builder: ((context, snapshot) => Row(children: [
        const Text("Enable Enrollment?"),
        Switch(value: snapshot.data != null, onChanged: (v) {
          if (v) {
            service.add(widget.program).then((_) {
              const snackBar = SnackBar(content: Text("Enrollment activated"));
              scaffoldMessenger.clearSnackBars();
              scaffoldMessenger.showSnackBar(snackBar);
            });
          } else {
            service.remove(widget.program).then((_) {
              const snackBar = SnackBar(content: Text("Enrollment deactivated"));
              scaffoldMessenger.clearSnackBars();
              scaffoldMessenger.showSnackBar(snackBar);
            });
          }
        },),
        if (snapshot.data != null) TextButton(onPressed: () async {
          await Clipboard.setData(ClipboardData(text: _signupLink()));
          const snackBar = SnackBar(content: Text("Link copied to clipboard"));
          scaffoldMessenger.showSnackBar(snackBar);
        }, child: const Text("Copy Invite Link")),
      ],))));
  }

  String _signupLink() {
    return "http://${Uri.base.authority}/#/signup/${widget.program.id}";
  }

}