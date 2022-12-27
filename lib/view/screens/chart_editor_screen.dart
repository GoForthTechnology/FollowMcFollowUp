
import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/files.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/fup_form_widget.dart';
import 'package:fmfu/view/widgets/recipe_control_widget.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:fmfu/view_model/recipe_control_view_model.dart';
import 'package:intl/intl.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';

class ChartEditorPage extends StatefulWidget with UiLoggy {
  static const String routeName = "charts";

  final int templateIndex;
  final CycleRecipe template;

  const ChartEditorPage({Key? key, required this.templateIndex, required this.template}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartEditorPageState();

  static Future<ChartEditorPageRoute> route(BuildContext context) async {
    final completer = Completer<ChartEditorPageRoute>();
    showDialog(context: context, builder: (context) => TemplateSelectorWidget(
      fn: (index, recipe) {
        completer.complete(ChartEditorPageRoute(templateIndex: index!, template: recipe!));
      }
    ));
    return completer.future;
  }
}

class TemplateSelectorWidget extends StatefulWidget {
  final void Function(int?, CycleRecipe?) fn;
  const TemplateSelectorWidget({super.key, required this.fn});

  @override
  State<StatefulWidget> createState() => _TemplateSelectorWidgetState();
}

class _TemplateSelectorWidgetState extends State<TemplateSelectorWidget> {
  int? selectedItem = 0;
  CycleRecipe? selectedRecipe;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ExerciseListViewModel>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text("Please select a scenario"),
      actions: [
        TextButton(onPressed: () {
          widget.fn(selectedItem, selectedRecipe);
          Navigator.of(context).pop();
        }, child: const Text("Submit")),
      ],
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("This will serve as a starting point for building your exercise."),
        FutureProvider<List<DynamicExercise>>(
          create: (_) => model.getTemplates(),
          initialData: const [],
          child: Consumer<List<DynamicExercise>>(
            builder: (context, exercises, _) {
              if (selectedItem != null && selectedRecipe == null && exercises.isNotEmpty) {
                selectedRecipe = exercises[selectedItem!].recipe;
              }
              return Form(key: formKey, child: DropdownButtonFormField<int>(
                value: selectedItem,
                items: exercises.mapIndexed((index, exercise) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(exercise.name),
                )).toList(),
                onChanged: (value) => setState(() {
                  selectedItem = value;
                  selectedRecipe = exercises[value!].recipe;
                }),
              ));
            },
          ),
        )
      ]),
    );
  }

}

typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _ChartEditorPageState extends State<ChartEditorPage> {

  @override
  void initState() {
    final model = Provider.of<ChartListViewModel>(context, listen: false);
    model.recipeControlViewModel.updateTemplateIndex(widget.templateIndex);
    model.recipeControlViewModel.applyTemplate(widget.template);
    super.initState();
  }

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
          body: Consumer2<ChartListViewModel, RecipeControlViewModel>(
            builder: (context, model, recipeModel, child) {
              //model.updateCharts(recipeModel.getRecipe());
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Center(child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Padding(padding: const EdgeInsets.all(20), child: _chartWidget(model)),
                        if (model.showFollowUpForm) const SingleChildScrollView(scrollDirection: Axis.horizontal, child: FollowUpFormWidget()),
                      ]))
                  )),
                  if (model.showCycleControlBar) const RecipeControlWidget(),
                ]),
              );},
          )
      );
    });
  }

  List<Widget> _actions(ChartListViewModel model) {
    final canRefresh = model.dynamicExerciseIssues().isEmpty;
    final refreshAction = canRefresh ? () {
      model.refreshCycles();
    } : null;
    final refreshTooltip = canRefresh ? "Refresh cycle from recipe" : "Refresh disabled to preserve edits";
    return [
      IconButton(icon: const Icon(Icons.refresh, color: Colors.white),
        onPressed: refreshAction, tooltip: refreshTooltip),
      IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {
        model.toggleControlBar();
      }, tooltip: "Open cycle settings panel",),
      IconButton(icon: const Icon(Icons.save, color: Colors.white), onPressed: () {
        _promptForSaveType(model);
      }, tooltip: "Save chart as an exercise",),
      IconButton(icon: const Icon(Icons.file_download, color: Colors.white), onPressed: () async {
        _promptForDownloadType(model);
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

  void _promptForDownloadType(ChartListViewModel model) {
    const itemSeparation = 10.0;
    const maxDialogWidth = 300.0;
    List<String> dynamicExerciseIssues = model.dynamicExerciseIssues();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Choose Exercise Type"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ConstrainedBox(constraints: const BoxConstraints.tightFor(width: maxDialogWidth), child: const Text(
            "Exercises can be downloaded as \"static exercises\" which will always show the same chart or \"dynamic exercises\" which will show charts using the recipe you have configured in the editor.")),
        const SizedBox(height: itemSeparation),
        const Text("Which exercise would you like to download?"),

        const SizedBox(height: itemSeparation * 2),
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop("OK");
          downloadJson(model.getStateAsJson(), "exercise.json");
        }, child: const Text("Static Exercise")),
        const SizedBox(height: itemSeparation),
        ElevatedButton(onPressed: dynamicExerciseIssues.isNotEmpty ? null : () {
          Navigator.of(context).pop("OK");
          downloadJson(model.getRecipeAsJson(), "recipe.json");
        }, child: const Text("Dynamic Exercise")),

        const SizedBox(height: itemSeparation * 2),
        if (dynamicExerciseIssues.isNotEmpty) ConstrainedBox(constraints: const BoxConstraints.tightFor(width: maxDialogWidth), child: const Text(
            "This chart cannot be saved as a dynamic exercise for the following reasons:")),
        ...dynamicExerciseIssues.map((issue) => Text("\u2022 $issue")),
      ],),
    ));
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
                ).then((val) {
                  int numExercises = exerciseModel.getExercises(exerciseType).where((e) => e.enabled).length;
                  exerciseModel.getCustomExercises(exerciseType)
                      .then((exercises) => exercises.where((e) => e.enabled).length)
                      .then((numCustomExercises) {
                    numExercises += numCustomExercises;
                    // This is brittle and will surely backfire sooner or later...
                    Provider.of<RecipeControlViewModel>(context, listen: false).updateTemplateIndex(numExercises - 1);
                    _showSnackBar("Saved \"$name\" as a ${exerciseType.name} exercise");
                  });
                }, onError: (exception) {
                  widget.loggy.warning(exception.toString());
                  _showSnackBar(exception.toString());
                  _showSaveDialog(model, exerciseType);
                });
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
        Text("If you'd like to save this chart as an exercise which can be revisited later, click the save button above.", style: TextStyle(fontStyle: FontStyle.italic)),
      ],
    ));
  }

  Widget titleButton(String title, VoidCallback onPressed) {
    return Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
      onPressed: onPressed, child: Text(title),
    ));
  }
}
