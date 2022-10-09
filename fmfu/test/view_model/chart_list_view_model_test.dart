

import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:test/test.dart';

void main() {

  group("Actions", ()
  {
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
  });
  group("Chart Navigation", () {
    test("Next & Previous Buttons", () {
      var viewModel = ChartListViewModel();
      int nCharts = 3;
      viewModel.updateCharts(CycleRecipe.standardRecipe, numCycles: nCharts * 6);

      expect(() => viewModel.moveToPreviousChart(), throwsException);

      expect(viewModel.showNextButton(), true);
      expect(viewModel.showPreviousButton(), false);

      viewModel.moveToNextChart();
      expect(viewModel.showNextButton(), true);
      expect(viewModel.showPreviousButton(), true);

      viewModel.moveToNextChart();
      expect(viewModel.showNextButton(), false);
      expect(viewModel.showPreviousButton(), true);

      expect(() => viewModel.moveToNextChart(), throwsException);

      viewModel.moveToPreviousChart();
      expect(viewModel.showNextButton(), true);
      expect(viewModel.showPreviousButton(), true);

      viewModel.moveToPreviousChart();
      expect(viewModel.showNextButton(), true);
      expect(viewModel.showPreviousButton(), false);
    });
  });
}