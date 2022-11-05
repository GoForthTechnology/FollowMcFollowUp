
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/files.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/control_bar_widget.dart';
import 'package:fmfu/view/widgets/fup_form_widget.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';

class ChartEditorPage extends StatefulWidget {
  static const String routeName = "charts";

  const ChartEditorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartEditorPageState();
}

typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _ChartEditorPageState extends State<ChartEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChartListViewModel>(builder: (context, model, child) {
      model.autoAdvanceToLastFollowup = true;  // Since we aren't showing next/previous buttons
      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text("Chart Editor"),
            actions: _actions(model),
          ),
          // TODO: figure out how to make horizontal scrolling work...
          body: Consumer<ChartListViewModel>(
            builder: (context, model, child) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  if (model.showCycleControlBar) ControlBarWidget(model: model),
                  Expanded(child: Center(child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Padding(padding: const EdgeInsets.all(20), child: _chartWidget(model)),
                        if (model.showFollowUpForm) const SingleChildScrollView(scrollDirection: Axis.horizontal, child: FollowUpFormWidget()),
                      ]))
                  )),
                ],
              ),
            ),
          )
      );
    });
  }

  List<Widget> _actions(ChartListViewModel model) {
    return [
      IconButton(icon: const Icon(Icons.play_arrow, color: Colors.white), onPressed: () {
        final state = ExerciseState.fromChartViewModel(model);
        AutoRouter.of(context).push(FollowUpSimulatorPageRoute(exerciseState: state));
      }, tooltip: "Run simulation with this chart",),
      IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {
        model.toggleControlBar();
      }, tooltip: "Open cycle settings panel",),
      IconButton(icon: const Icon(Icons.save, color: Colors.white), onPressed: () {
        _promptForSaveType(model);
      }, tooltip: "Save chart as an exercise",),
      IconButton(icon: const Icon(Icons.file_download, color: Colors.white), onPressed: () async {
        downloadJson(model.getStateAsJson(), "exercise.json");
      }, tooltip: "Download current chart",),
      IconButton(icon: const Icon(Icons.file_upload, color: Colors.white), onPressed: () async {
        openJsonFile().then((file) async {
          if (file == null) {
            _showSnackBar("No file selected");
          }
          final contents = await file!.readAsString();
          model.restoreStateFromJson(
              ExerciseState.fromJson(jsonDecode(contents)));
          _showSnackBar("Loaded ${file.name}");
        }, onError: (error) => _showSnackBar(error.toString()));
      }, tooltip: "Load chart from file",),
    ];
  }

  void _promptForSaveType(ChartListViewModel model) {
    const itemSeparation = 10.0;
    const maxDialogWidth = 300.0;
    List<String> dynamicExerciseIssues = model.dynamicExerciseIssues();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Choose Exercise Type"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ConstrainedBox(constraints: const BoxConstraints.tightFor(width: maxDialogWidth), child: const Text(
            "Exercises can be saved as \"static exercises\" which will always show the same chart or \"dynamic exercises\" which will show charts using the recipe you have configured in the editor.")),
        const SizedBox(height: itemSeparation),
        const Text("Which exercise would you like to create?"),

        const SizedBox(height: itemSeparation * 2),
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop("OK");
          _showSaveDialog(model, ExerciseType.static);
        }, child: const Text("Static Exercise")),
        const SizedBox(height: itemSeparation),
        ElevatedButton(onPressed: dynamicExerciseIssues.isNotEmpty ? null : () {
          Navigator.of(context).pop("OK");
          _showSaveDialog(model, ExerciseType.dynamic);
        }, child: const Text("Dynamic Exercise")),

        const SizedBox(height: itemSeparation * 2),
        if (dynamicExerciseIssues.isNotEmpty) ConstrainedBox(constraints: const BoxConstraints.tightFor(width: maxDialogWidth), child: const Text(
            "This chart cannot be saved as a dynamic exercise for the following reasons:")),
        ...dynamicExerciseIssues.map((issue) => Text("\u2022 $issue")),
      ],),
    ));
  }

  void _showSaveDialog(ChartListViewModel model, ExerciseType exerciseType) {
    showDialog(context: context, builder: (context) {
      final formKey = GlobalKey<FormState>();
      void saveForm() {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          Navigator.of(context).pop("OK");
        }
      }
      return Consumer<ExerciseListViewModel>(builder: (context, exerciseModel, child) => AlertDialog(
        title: Text("Save Chart as ${toBeginningOfSentenceCase(exerciseType.name)} Exercises"),
        content: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Please provide a name for the exercise."),
            TextFormField(
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Name required";
                }
                return null;
              },
              onSaved: (name) {
                // TODO: fix error scenario probabilities
                Map<ErrorScenario, double> errorScenarios = {};
                for (var errorScenario in model.errorScenarios) {
                  errorScenarios[errorScenario] = 1.0;
                }
                exerciseModel.addCustomExercise(
                  name: name!,
                  exerciseType: exerciseType,
                  chart: model.charts[0],
                  recipe: model.recipe,
                  errorScenarios: errorScenarios,
                );
                _showSnackBar("Saved \"$name\" as a ${exerciseType.name} exercise");
              },
              onFieldSubmitted: (name) {
                saveForm();
              },
            ),

          ]),
        ),
        actions: [
          TextButton(onPressed: () => saveForm(), child: const Text("Save")),
        ],
      ));
    });
  }

  void _showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ChartWidget _chartWidget(ChartListViewModel model) {
    return  ChartWidget(
      model: model,
      editingEnabled: model.editEnabled,
      correctingEnabled: !model.editEnabled,
      showErrors: model.showErrors,
      titleWidget: _chartTitleWidget(model),
      chart: model.charts[model.chartIndex],
      rightWidgetFn: (cycle) => Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            child: const Text("Run Correcting\nExercise"),
            onPressed: () {
              AutoRouter.of(context).push(ChartCorrectingScreenRoute(cycle: cycle));
            },
          )
      ),
    );
  }

  Widget _chartTitleWidget(ChartListViewModel model) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Select a stamp or observation to make an edit or open the settings panel to: alter the cycle recipe, add follow ups, change instructions, etc.", style: TextStyle(fontStyle: FontStyle.italic)),
        SizedBox(height: 10),
        Text("When you're done editing, click the play button to run a follow up simulation or select \"Run Correcting Exercise\" to practice chart corrections.", style: TextStyle(fontStyle: FontStyle.italic)),
        SizedBox(height: 10),
        Text("If you'd like to save this chart as an exercise which can be revisited later, clicke the save button above.", style: TextStyle(fontStyle: FontStyle.italic)),
      ],
    ));
  }

  Widget titleButton(String title, VoidCallback onPressed) {
    return Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
      onPressed: onPressed, child: Text(title),
    ));
  }
}
