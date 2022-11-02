
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:fmfu/model/exercise.dart';
import 'package:fmfu/routes.gr.dart';
import 'package:fmfu/utils/files.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/control_bar_widget.dart';
import 'package:fmfu/view/widgets/fup_form_widget.dart';
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
            actions: [
              IconButton(icon: Icon(model.showErrors ? Icons.visibility_off: Icons.visibility, color: Colors.white), onPressed: () {
                model.toggleShowErrors();
              },),
              IconButton(icon: Icon(model.editEnabled ? Icons.edit_off: Icons.edit, color: Colors.white), onPressed: () {
                model.toggleEdit();
              },),
              IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {
                model.toggleControlBar();
              },),
              IconButton(icon: const Icon(Icons.save, color: Colors.white), onPressed: () async {
                downloadJson(model.getStateAsJson(), "exercise.json");
              },),
              IconButton(icon: const Icon(Icons.open_in_browser, color: Colors.white), onPressed: () async {
                openJsonFile().then((file) async {
                  if (file == null) {
                    _showSnackBar("No file selected");
                  }
                  final contents = await file!.readAsString();
                  model.restoreStateFromJson(
                      ExerciseState.fromJson(jsonDecode(contents)));
                  _showSnackBar("Loaded ${file.name}");
                }, onError: (error) => _showSnackBar(error.toString()));
              },),
            ],
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

  void _showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ChartWidget _chartWidget(ChartListViewModel model) {
    return  ChartWidget(
      model: model,
      editingEnabled: model.editEnabled,
      correctingEnabled: true,
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
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(
      children: [
        Text(
          "${model.editEnabled ? "Editing " : ""}Chart #${model.chartIndex+1}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        titleButton("Previous", () => model.showPreviousButton() ? () => model.moveToPreviousChart() : null),
        titleButton("Next", () => model.showNextButton() ? () => model.moveToNextChart() : null),
        titleButton("Run Simulation", () {
          final state = ExerciseState.fromChartViewModel(model);
          AutoRouter.of(context).push(FollowUpSimulatorPageRoute(exerciseState: state));
        }),
        if (model.editEnabled) const Padding(padding: EdgeInsets.only(left: 10), child: Text("Select a sticker or observation to make an edit.", style: TextStyle(fontStyle: FontStyle.italic))),
        if (model.showErrors) const Padding(padding: EdgeInsets.only(left: 10), child: Text("All charting errors (if any) are now highlighted in pink.", style: TextStyle(fontStyle: FontStyle.italic))),
      ],
    ));
  }

  Widget titleButton(String title, VoidCallback onPressed) {
    return Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
      onPressed: onPressed, child: Text(title),
    ));
  }
}
