
import 'package:flutter/material.dart';
import 'package:fmfu/model/program.dart';
import 'package:fmfu/utils/screen_widget.dart';
import 'package:fmfu/view_model/group_exercise_list_view_model.dart';
import 'package:provider/provider.dart';

class GroupExerciseListScreen extends ScreenWidget {
  GroupExerciseListScreen({super.key});

  Widget _body(BuildContext context, GroupExerciseListViewModel model) {
    if (model.programs.isEmpty) {
      return const Text("No programs found");
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: model.programs.length,
        itemBuilder: (BuildContext context, int index) {
          var program = model.programs[index];
          return Row(children: [
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: Padding(padding: const EdgeInsets.all(10), child: Text(
              "Program: ${program.title}",
              style: const TextStyle(fontSize: 18),
            ))),
            const Spacer(),
          ]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logScreenView("GroupExerciseListScreen");

    return Consumer<GroupExerciseListViewModel>(builder: (context, model, child) => Scaffold(
      appBar: AppBar(
        title: const Text("Group Exercises"),
      ),
      body: Center(child: _body(context, model)),
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
                      final program = Program(value);
                      model.addProgram(program);
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
    ));
  }

}