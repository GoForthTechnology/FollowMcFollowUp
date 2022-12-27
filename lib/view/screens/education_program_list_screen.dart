

import 'package:flutter/material.dart';
import 'package:fmfu/api/education_program_service.dart';
import 'package:fmfu/model/education_program.dart';
import 'package:fmfu/utils/stream_widget.dart';
import 'package:provider/provider.dart';

class EducationProgramListScreen extends StatelessWidget {
  const EducationProgramListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EducationProgramService>(
      builder: (context, service, _) => ChangeNotifierProvider(
        create: (_) => _ViewModel(service),
        child: _EducationProgramListContent(),
      ),
    );
  }
}

class _ViewState {

  final List<EducationProgram> programs;

  _ViewState({
    this.programs = const [],
  });
}

class _ViewModel extends WidgetModel<_ViewState> {
  final EducationProgramService _service;

  _ViewModel(this._service) {
    _service.streamAll()
        .map((programs) => _ViewState(programs: programs))
        .listen(updateState);
  }

  @override
  _ViewState initialState() {
    return _ViewState();
  }
}

class _EducationProgramListContent extends StreamWidget<_ViewModel, _ViewState> {

  @override
  Widget render(BuildContext context, _ViewState state, _ViewModel model) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Education Programs"),
      ),
      body: Center(child: content(state)),
      floatingActionButton: FloatingActionButton(
        child: const Text("+"),
        onPressed: () {
          var formKey = GlobalKey<FormState>();
          saveForm() {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
            }
          }
          showDialog(context: context, builder: (context) => AlertDialog(
            title: const Text("New Group Exercise"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Exercise Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Value required";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) => saveForm(),
                    onSaved: (value) {
                      if (value == null) {
                        throw Exception("Title required to create a program");
                      }
                      Navigator.pop(context, 'OK');
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => saveForm(),
                child: const Text("Submit"),
              ),
            ],
          ));
        },
      ),
    );
  }

  Widget content(_ViewState state) {
    if (state.programs.isEmpty) {
      return const Text("No programs found");
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: state.programs.length,
        itemBuilder: (BuildContext context, int index) {
          var program = state.programs[index];
          return Row(children: [
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: Padding(padding: const EdgeInsets.all(10), child: Text(
              "Program: ${program.name}",
              style: const TextStyle(fontSize: 18),
            ))),
            const Spacer(),
          ]);
        },
      ),
    );
  }
}