
import 'dart:convert';

import 'package:fmfu/utils/files.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/control_bar_widget.dart';
import 'package:fmfu/view/widgets/fup_form_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';

class ChartPage extends StatefulWidget {
  static const String routeName = "charts";

  const ChartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartPageState();
}

typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChartListViewModel>(builder: (context, model, child) => Scaffold(
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
          IconButton(icon: Icon(model.showFollowUpForm ? Icons.grid_off : Icons.grid_on, color: Colors.white), onPressed: () {
            model.toggleShowFollowUpForm();
          },),
          IconButton(icon: Icon(model.incrementalMode ? Icons.extension_off : Icons.extension, color: Colors.white), onPressed: () {
            model.toggleIncrementalMode();
          },),
          IconButton(icon: const Icon(Icons.download, color: Colors.white), onPressed: () async {
            var json = const JsonEncoder.withIndent("  ").convert(model.getStateAsJson());
            downloadJson(json, "exercise.json");
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
    ));
  }

  ChartWidget _chartWidget(ChartListViewModel model) {
    return  ChartWidget(
      model: model,
      editingEnabled: model.editEnabled,
      correctingEnabled: true,
      showErrors: model.showErrors,
      titleWidget: _chartTitleWidget(model),
      chart: model.charts[model.chartIndex],
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
        Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
          onPressed: model.showPreviousButton() ? () => model.moveToPreviousChart() : null,
          child: const Text("Previous"),
        )),
        Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
          onPressed: model.showNextButton() ? () => model.moveToNextChart() : null,
          child: const Text("Next"),
        )),
        if (model.editEnabled) const Padding(padding: EdgeInsets.only(left: 10), child: Text("Select a sticker or observation to make an edit.", style: TextStyle(fontStyle: FontStyle.italic))),
        if (model.showErrors) const Padding(padding: EdgeInsets.only(left: 10), child: Text("All charting errors (if any) are now highlighted in pink.", style: TextStyle(fontStyle: FontStyle.italic))),
        if (model.followUps().isNotEmpty) ...[
          Padding(padding: const EdgeInsets.only(left: 20), child: Text(
            "Current Follow Up: #${model.currentFollowUpNumber()}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
          Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: model.hasPreviousFollowUp() ? () {
                model.goToPreviousFollowup();
              } : null,
              child: const Text("Previous Followup"))),
          Padding(padding: const EdgeInsets.only(left: 20), child: ElevatedButton(
              onPressed: model.hasNextFollowUp() ? () {
                model.goToNextFollowup();
              } : null,
              child: const Text("Next Followup"))),
        ],
      ],
    ));
  }
}
