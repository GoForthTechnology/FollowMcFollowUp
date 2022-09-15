
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:test/test.dart';

void main() {
 group("Actions", () {
   test("Toggle control bar", () {
     var viewModel = ChartListViewModel();
     expect(viewModel.showCycleControlBar, false);

     viewModel.toggleControlBar();
     expect(viewModel.showCycleControlBar, true);

     viewModel.toggleControlBar();
     expect(viewModel.showCycleControlBar, false);
   });
   test("Toggle control bar", () {
     var viewModel = ChartListViewModel();
     expect(viewModel.editEnabled, false);

     viewModel.toggleEdit();
     expect(viewModel.editEnabled, true);

     viewModel.toggleEdit();
     expect(viewModel.editEnabled, false);
   });
   test("Toggle followup form", () {
     var viewModel = ChartListViewModel();
     expect(viewModel.showFollowUpForm, false);

     viewModel.toggleShowFollowUpForm();
     expect(viewModel.showFollowUpForm, true);

     viewModel.toggleShowFollowUpForm();
     expect(viewModel.showFollowUpForm, false);
   });
   test("Toggle errors", () {
     var viewModel = ChartListViewModel();
     expect(viewModel.showErrors, false);

     viewModel.toggleShowErrors();
     expect(viewModel.showErrors, true);

     viewModel.toggleShowErrors();
     expect(viewModel.showErrors, false);
   });
   test("Toggle incremental mode", () {
     var viewModel = ChartListViewModel();
     expect(viewModel.incrementalMode, false);
     expect(viewModel.cycles.isNotEmpty, true);

     viewModel.toggleIncrementalMode();
     expect(viewModel.incrementalMode, true);
     expect(viewModel.cycles.isEmpty, true);

     viewModel.toggleIncrementalMode();
     expect(viewModel.incrementalMode, false);
     expect(viewModel.cycles.isNotEmpty, true);
   });
 });
 group("Chart Navigation", () {
   test("Next & Previous Buttons", () {
     var viewModel = ChartListViewModel();
     int nCharts = 3;
     viewModel.updateCharts(CycleRecipe.standardRecipe, numCycles: nCharts * 6);

     expect(viewModel.showNextButton(), true);
     expect(viewModel.showPreviousButton(), false);

     viewModel.moveToNextChart();
     expect(viewModel.showNextButton(), true);
     expect(viewModel.showPreviousButton(), true);

     viewModel.moveToNextChart();
     expect(viewModel.showNextButton(), false);
     expect(viewModel.showPreviousButton(), true);

     viewModel.moveToPreviousChart();
     expect(viewModel.showNextButton(), true);
     expect(viewModel.showPreviousButton(), true);

     viewModel.moveToPreviousChart();
     expect(viewModel.showNextButton(), true);
     expect(viewModel.showPreviousButton(), false);
   });
 });
 group("Chart Updates", () {
   test("Normal Cycle Length", () {
     var viewModel = ChartListViewModel();
     int nCharts = 2;
     int nCycles = nCharts * 6 - 1;
     viewModel.updateCharts(CycleRecipe.standardRecipe, numCycles: nCycles);

     bool hasCycle(CycleSlice slice) {
       return slice.cycle != null;
     }

     expect(viewModel.cycles.length, nCycles);
     expect(viewModel.charts.length, nCharts);
     expect(viewModel.charts[0].cycles.where(hasCycle).length, 6);
     expect(viewModel.charts[1].cycles.where(hasCycle).length, 5);
   });

   test("Long cycles", () {
     var viewModel = ChartListViewModel();
     int nCycles = 5;
     int targetCycleLength = 42;
     int postPeakLength = targetCycleLength + CycleRecipe.defaultPostPeakLength - CycleRecipe.defaultCycleLength;

     var recipe = CycleRecipe.create(postPeakLength: postPeakLength, stdDev: 0);
     viewModel.updateCharts(recipe, numCycles: nCycles);

     for (var cycle in viewModel.cycles) {
       expect(cycle.entries.length, greaterThan(35));
     }

     bool hasCycle(CycleSlice slice) {
       return slice.cycle != null;
     }

     expect(viewModel.cycles.length, nCycles);
     expect(viewModel.charts.length, 2);
     expect(viewModel.charts[0].cycles.where(hasCycle).length, 6);
     expect(viewModel.charts[1].cycles.where(hasCycle).length, 4);
   });
 });
}