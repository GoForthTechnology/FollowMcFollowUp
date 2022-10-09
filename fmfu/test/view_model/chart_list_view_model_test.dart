

import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:test/test.dart';

import 'chart_view_model_test.dart';

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
  group("Cycle stats", () {
    group("Length of post peak phase", () {
      test("CRUD", () {
        var viewModel = ChartListViewModel();
        expect(viewModel.cycles[0].cycleStats.lengthOfPostPeakPhase, null);

        var expectedLength = 12;
        viewModel.setLengthOfPostPeakPhase(0, expectedLength);
        expect(viewModel.cycles[0].cycleStats.lengthOfPostPeakPhase, expectedLength);
      });
      test("Invalid cycle index", () {
        var viewModel = ChartListViewModel();
        var invalidIndex = viewModel.cycles.length;
        expect(() => viewModel.setLengthOfPostPeakPhase(invalidIndex, 12), throwsException);
      });
    });

    group("Mucus cycle score", () {
      test("CRUD", () {
        var viewModel = ChartListViewModel();
        viewModel.cycles.add(fakeCycle(28));
        expect(viewModel.cycles[0].cycleStats.mucusCycleScore, null);

        var expectedScore = 1.2;
        viewModel.setMucusCycleScore(0, expectedScore);
        expect(viewModel.cycles[0].cycleStats.mucusCycleScore, expectedScore);
      });
      test("Invalid cycle index", () {
        var viewModel = ChartListViewModel();
        var invalidIndex = viewModel.cycles.length;
        expect(() => viewModel.setMucusCycleScore(invalidIndex, 1.5), throwsException);
      });
    });
  });
}