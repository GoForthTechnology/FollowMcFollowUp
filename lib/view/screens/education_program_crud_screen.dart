
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/api/education_program_service.dart';
import 'package:fmfu/api/user_service.dart';
import 'package:fmfu/model/assignment.dart';
import 'package:fmfu/model/education_program.dart';
import 'package:fmfu/model/student_profile.dart';
import 'package:fmfu/utils/stream_widget.dart';
import 'package:fmfu/view/widgets/add_student_dialog.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:tuple/tuple.dart';

import '../widgets/input_container.dart';

class EducationProgramCrudScreen extends StatelessWidget {
  final String? programId;

  const EducationProgramCrudScreen({super.key, @PathParam() this.programId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<EducationProgramService, UserService>(builder: (context, educationService, userService, _) {
      return ChangeNotifierProvider(
        create: (_) => _ViewModel(userService, educationService, programId),
        child: _EducationProgramCrudContent(),
      );
    });
  }
}

class _ViewState {

  final String? _id;
  final String pageTitle;
  final String? name;
  final LocalDate? ep1Date;
  final LocalDate? ep2Date;
  final List<StudentProfile> students;
  final Map<String, bool> selectedStudents;

  _ViewState(this.pageTitle, this._id, this.name, this.ep1Date, this.ep2Date, this.students, this.selectedStudents);

  bool hasBeenSaved() {
    return _id != null;
  }

  bool canSelectStudents() {
    return hasBeenSaved();
  }

  bool canSelectAssignments() {
    return hasBeenSaved();
  }

  EducationProgram program() {
    var enrolledStudents = selectedStudents.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    return EducationProgram(name!, _id, ep1Date!, ep2Date!, enrolledStudentIds: enrolledStudents);
  }
}

class _ViewModel extends WidgetModel<_ViewState> with GlobalLoggy {

  final String? _initialId;
  final EducationProgramService _programService;

  final formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final nameStreamController = StreamController<String?>();
  final ep1DateController = StreamController<LocalDate?>();
  final ep2DateController = StreamController<LocalDate?>();
  final idController = StreamController<String?>();
  final studentSelections = StreamController<Tuple2<String, bool>>();

  _ViewState createState(
      LocalDate? ep1Date,
      LocalDate? ep2Date,
      String? name,
      String? id,
      List<StudentProfile> students,
      Map<String, bool>? selectedStudents) {
    return _ViewState(_title(id), id, name, ep1Date, ep2Date, students, selectedStudents ?? {});
  }

  _ViewModel(UserService userService, this._programService, this._initialId) {
    Rx.combineLatest6(
        ep1DateController.stream,
        ep2DateController.stream,
        nameStreamController.stream,
        idController.stream,
        userService.getAllStudents(),
        studentSelections.stream.scan<Map<String, bool>>((accumulated, value, index) {
          accumulated[value.item1] = value.item2;
          return accumulated;
        }, {}),
        createState)
    .listen(updateState);

    nameTextController.addListener(() => nameStreamController.add(nameTextController.text));

    idController.add(_initialId);
    studentSelections.add(const Tuple2<String, bool>("", false));
    if (_initialId == null) {
      ep1DateController.add(null);
      ep2DateController.add(null);
    } else {
      _programService.stream(_initialId!).listen((program) {
        if (program == null) {
          loggy.warning("Could not find program for ID: $_initialId");
        } else {
          ep1DateController.add(program.ep1Date);
          ep2DateController.add(program.ep2Date);
          nameTextController.text = program.name;
          for (var id in program.enrolledStudentIds) {
            studentSelections.add(Tuple2(id, true));
          }
        }
      });
    }
  }

  @override
  _ViewState initialState() {
    return _ViewState(_title(_initialId), _initialId, null, null, null, [], {});
  }

  String _title(String? programId) {
    if (programId == null) {
      return "New Program";
    }
    return "Edit Program";
  }

  Future<void> save(_ViewState state) async {
    if (formKey.currentState!.validate()) {
      if (!state.hasBeenSaved()) {
        idController.add(await _programService.addProgram(state.program()));
      } else {
        _programService.updateProgram(state.program());
      }
    }
  }
}

class _EducationProgramCrudContent extends StreamWidget<_ViewModel, _ViewState> with UiLoggy {
  @override
  Widget render(BuildContext context, _ViewState state, _ViewModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.pageTitle),
        actions: [
          IconButton(onPressed: () => model.save(state), icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(20), child: Form(key: model.formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        _sectionHeading(context, "General Information"),
        _buildNameWidget(context, state, model),
        _buildEp1DateWidget(context, state, model),
        _buildEp2DateWidget(context, state, model),
        _sectionHeading(context, "Student Roster"),
        _buildStudentRoster(context, state, model),
        _sectionHeading(context, "Assignment Information"),
        _buildAssignments(context, state),
      ])),
    ));
  }

  Widget _buildStudentRoster(BuildContext context, _ViewState state, _ViewModel model) {
    if (!state.canSelectStudents()) {
      return Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(
        "Please save the program to begin selecting students",
        style: Theme.of(context).textTheme.bodyText2,
      ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListView.builder(
        shrinkWrap: true,
        itemCount: state.students.length,
        itemBuilder: (context, index) {
          var student = state.students[index];
          var selected = state.selectedStudents.containsKey(student.id) && state.selectedStudents[student.id]!;
          return Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text("${student.fullName()} (${student.emailAddress})"),
            Checkbox(value: selected, onChanged: (value) {
              model.studentSelections.add(Tuple2<String, bool>(student.id!, value ?? false));
            }),
          ]));
        },
      ),
      Padding(padding: const EdgeInsets.all(20), child: ElevatedButton(
        onPressed: () => showDialog(context: context, builder: (context) => const AddStudentDialog()),
        child: const Text("Add a Student"),
      )),
    ]);
  }

  Widget _buildAssignments(BuildContext context, _ViewState state) {
    if (!state.canSelectAssignments()) {
      return Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(
        "Please save the program to begin selecting assignments",
        style: Theme.of(context).textTheme.bodyText2,
      ));
    }
    return Padding(padding: const EdgeInsets.all(20), child: ElevatedButton(
      onPressed: () => showDialog(context: context, builder: (context) => const AssignmentDialog()),
      child: const Text("Add an Assignment"),
    ));
  }

  Widget _sectionHeading(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildNameWidget(BuildContext context, _ViewState state, _ViewModel model) {
    return InputContainer(title: "Program Name:", content: ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 200),
      child: TextFormField(
        validator: (value) {
          if (value == null) {
            loggy.debug("Name required");
            return "Name required";
          }
          return null;
        },
        controller: model.nameTextController,
      ),
    ));
  }

  Widget _buildEp1DateWidget(BuildContext context, _ViewState state, _ViewModel model) {
    return _buildEpDateWidget(context, "EP I Date", state.ep1Date, model.ep1DateController);
  }

  Widget _buildEp2DateWidget(BuildContext context, _ViewState state, _ViewModel model) {
    return _buildEpDateWidget(context, "EP II Date", state.ep2Date, model.ep2DateController);
  }

  Widget _buildEpDateWidget(BuildContext context, String title, LocalDate? currentDate, StreamController<LocalDate?> controller) {
    var dateStr = currentDate == null ? "Select a date" : currentDate.toString();
    final Widget display = Text(dateStr);
    return InputContainer(
      title: title,
      content: FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: currentDate?.toDateTimeUnspecified(),
        validator: (value) {
          if (value == null) {
            loggy.debug("Date required for $title");
            return "Date required";
          }
          return null;
        },
        builder: (state) => GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: currentDate?.toDateTimeUnspecified() ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              state.didChange(picked);
              controller.add(LocalDate.dateTime(picked));
            }
          },
          child: display,
        ),
      ),
    );
  }
}

class AssignmentDialog extends StatelessWidget {
  const AssignmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var router = AutoRouter.of(context);
    var buttons = AssignmentType.values
        .map((type) => Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () => router.pop(),
            child: Text(type.description),
          ),
        ))
        .toList();
    return AlertDialog(
      title: const Text("Add Assignment"),
      content: Column(mainAxisSize: MainAxisSize.min, children: buttons),
      actions: [
        TextButton(onPressed: () => router.pop(), child: const Text("Close"))
      ],
    );
  }
}