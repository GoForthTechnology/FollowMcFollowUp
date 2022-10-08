
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:test/test.dart';

void main() {
  group("Follow Ups", () {
    test("Add invalid followup", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      expect(() =>
          viewModel.addFollowUp(viewModel.latestStartOfCharting().addDays(1)),
          throwsException);
      expect(() =>
          viewModel.addFollowUp(
              viewModel.earliestStartOfCharting().subtractDays(1)),
          throwsException);
    });

    test("Add duplicate followup", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      viewModel.addFollowUp(viewModel.startOfCharting().addDays(1));
      expect(() =>
          viewModel.addFollowUp(viewModel.startOfCharting().addDays(1)),
          throwsException);
    });

    test("Current follow up number", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(2 * 365));
      expect(viewModel.currentFollowUpNumber(), null);

      for (int i = 1; i < 10; i++) {
        viewModel.addFollowUp(viewModel.nextFollowUpDate());
        viewModel.goToNextFollowup();
        expect(viewModel.currentFollowUpNumber(), i);
      }
    });

    test("Has and go to next follow up", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      expect(viewModel.hasNextFollowUp(), false);

      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.hasNextFollowUp(), false); // auto advance

      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.hasNextFollowUp(), true);

      viewModel.goToNextFollowup();
      expect(viewModel.hasNextFollowUp(), false);
    });

    test("Has and go to previous follow up", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      expect(viewModel.hasPreviousFollowUp(), false);
      viewModel.goToPreviousFollowup(); // should not throw exception;

      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.hasPreviousFollowUp(), false);

      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.hasPreviousFollowUp(), false);

      viewModel.goToNextFollowup();
      expect(viewModel.hasPreviousFollowUp(), true);

      viewModel.goToPreviousFollowup();
      expect(viewModel.hasPreviousFollowUp(), false);
    });

    test("Remove followup", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      expect(viewModel
          .followUps()
          .isEmpty, true);

      var followUpDate = viewModel.startOfCharting().addDays(1);
      viewModel.addFollowUp(followUpDate);
      expect(viewModel
          .followUps()
          .isEmpty, false);
      expect(viewModel.hasFollowUp(followUpDate), true);
      expect(viewModel.currentFollowUpDate(), followUpDate);

      viewModel.removeFollowUp(followUpDate);
      expect(viewModel.hasFollowUp(followUpDate), false);
      expect(viewModel.currentFollowUpDate(), null);
      expect(viewModel
          .followUps()
          .isEmpty, true);
    });

    test("Add several followups", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      expect(viewModel.currentFollowUpNumber(), null);
      expect(viewModel.currentFollowUpDate(), null);
      expect(viewModel
          .followUps()
          .length, 0);
      var followUpDate = viewModel.startOfCharting().addDays(14);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // First follow up
      viewModel.addFollowUp(followUpDate);
      expect(viewModel.hasFollowUp(followUpDate), true);
      expect(viewModel
          .followUps()
          .length, 1);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(2 * 14);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Second follow up
      viewModel.addFollowUp(followUpDate);
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 2);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(3 * 14);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Third follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 3);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(4 * 14);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Fourth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 4);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(4 * 14 + 1 * 28);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Fifth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 5);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(2 * 3 * 28);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Sixth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 6);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(3 * 3 * 28);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Seventh follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 7);
      expect(viewModel.currentFollowUpDate(), followUpDate);
      followUpDate = viewModel.startOfCharting().addDays(4 * 3 * 28);
      expect(viewModel.nextFollowUpDate(), followUpDate);

      // Eighth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.hasFollowUp(followUpDate);
      viewModel.goToNextFollowup();
      expect(viewModel
          .followUps()
          .length, 8);
      expect(viewModel.currentFollowUpNumber(), 8);
      expect(viewModel.currentFollowUpDate(),
          viewModel.startOfCharting().addDays(4 * 3 * 28));
      expect(viewModel.nextFollowUpDate(),
          viewModel.startOfCharting().addDays(5 * 3 * 28));
    });
  });

  group("Start of charting", () {
    test("Earliest start of charting", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      expect(viewModel.startOfCharting(), viewModel.earliestStartOfCharting());

      viewModel.cycles.add(fakeCycle(28));
      expect(viewModel.startOfCharting(), viewModel.earliestStartOfCharting());
    });

    test("Latest start of charting", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      expect(viewModel.latestStartOfCharting(),
          viewModel.earliestStartOfCharting());

      viewModel.cycles.add(fakeCycle(28));
      expect(viewModel.latestStartOfCharting(),
          viewModel.earliestStartOfCharting().addDays(28));
    });

    test("Set start of charting", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(28));
      expect(viewModel.startOfCharting(), viewModel.earliestStartOfCharting());

      expect(() =>
          viewModel.setStartOfCharting(
              viewModel.earliestStartOfCharting().subtractDays(1)),
          throwsException);
      expect(() =>
          viewModel.setStartOfCharting(
              viewModel.earliestStartOfCharting().addDays(29)),
          throwsException);

      viewModel.setStartOfCharting(
          viewModel.earliestStartOfCharting().addDays(10));
      expect(viewModel.startOfCharting(),
          viewModel.earliestStartOfCharting().addDays(10));
    });
  });

  group("Update Sticker Correction", () {
    test("Valid cycle", () {
      var viewModel = ChartViewModelForTest();
      viewModel.addCycle(CycleRecipe.create());

      for (var cycle in viewModel.cycles) {
        expect(cycle.stickerCorrections.isEmpty, true);
      }

      var correction = StickerWithText(Sticker.green, null);
      viewModel.updateStickerCorrections(0, 0, correction);
      expect(viewModel.cycles[0].stickerCorrections[0], correction);

      viewModel.updateStickerCorrections(0, 0, null);
      expect(viewModel.cycles[0].stickerCorrections.isEmpty, true);

      expect(viewModel.numUpdates, 3);
    });
    test("Invalid cycle", () {
      var viewModel = ChartViewModelForTest();
      var correction = StickerWithText(Sticker.green, null);
      expect(() => viewModel.updateStickerCorrections(1, 0, correction), throwsException);
    });
  });

  group("Update Observation Correction", () {
    test("Valid cycle", () {
      var viewModel = ChartViewModelForTest();
      viewModel.addCycle(CycleRecipe.create());

      for (var cycle in viewModel.cycles) {
        expect(cycle.observationCorrections.isEmpty, true);
      }

      var correction = "0 AD";
      viewModel.updateObservationCorrections(0, 0, correction);
      expect(viewModel.cycles[0].observationCorrections[0], correction);

      viewModel.updateObservationCorrections(0, 0, null);
      expect(viewModel.cycles[0].observationCorrections.isEmpty, true);

      expect(viewModel.numUpdates, 3);
    });
    test("Invalid cycle", () {
      var viewModel = ChartViewModelForTest();
      expect(() => viewModel.updateObservationCorrections(1, 0, "0 AD"), throwsException);
    });
  });

  group("Edit Sticker", () {
    test("Valid Cycle", () {
      var viewModel = ChartViewModelForTest();
      viewModel.addCycle(CycleRecipe.create());

      for (var cycle in viewModel.cycles) {
        for (var entry in cycle.entries) {
          expect(entry.manualSticker, isNull);
        }
      }

      var edit = StickerWithText(Sticker.whiteBaby, "P");
      viewModel.editSticker(0, 0, edit);
      expect(viewModel.cycles[0].entries[0].manualSticker, edit);

      viewModel.editSticker(0, 0, null);
      expect(viewModel.cycles[0].entries[0].manualSticker, isNull);

      expect(viewModel.numUpdates, 3);
    });
    test("Invalid cycle", () {
      var viewModel = ChartViewModelForTest();
      var sticker  = StickerWithText(Sticker.green, null);
      expect(() => viewModel.editSticker(1, 0, sticker), throwsException);
    });
    test("Invalid entry", () {
      var viewModel = ChartViewModelForTest();
      viewModel.addFakeCycle(fakeCycle(28));
      viewModel.editEntry(0, 0, "0");

      var entry = viewModel.cycles[0].entries[0];
      expect(entry.observationText, "0");
    });
  });

  test("Edit Observation", () {
    var viewModel = ChartViewModelForTest();
    viewModel.addCycle(CycleRecipe.create());

    for (var cycle in viewModel.cycles) {
      for (var entry in cycle.entries) {
        expect(entry.manualSticker, isNull);
      }
    }

    var edit = "4 AD";
    viewModel.editEntry(0, 0, edit);
    expect(viewModel.cycles[0].entries[0].observationText, edit);

    viewModel.editSticker(0, 0, null);
    expect(viewModel.cycles[0].entries[0].observationText, viewModel.cycles[0].entries[0].renderedObservation!.getObservationText());

    expect(viewModel.numUpdates, 3);
  });

  group("Actions", () {
    test("Toggle incremental mode", () {
      var viewModel = ChartViewModelForTest();
      expect(viewModel.incrementalMode, true);

      viewModel.toggleIncrementalMode();
      expect(viewModel.incrementalMode, false);

      viewModel.toggleIncrementalMode();
      expect(viewModel.incrementalMode, true);
      expect(viewModel.cycles.isEmpty, true);

      viewModel.toggleIncrementalMode();
      expect(viewModel.incrementalMode, false);
      expect(viewModel.cycles.isNotEmpty, true);
    });
  });
  group("Chart Updates", () {
    test("Normal Cycle Length", () {
      var viewModel = ChartViewModelForTest();
      viewModel.toggleIncrementalMode();

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
      var viewModel = ChartViewModelForTest();
      viewModel.toggleIncrementalMode();

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
  group("Add Cycle", () {
    test("Does nothing when not in incremental mode", () {
      var viewModel = ChartViewModelForTest();
      viewModel.toggleIncrementalMode();

      var numInitialCycles = viewModel.cycles.length;

      viewModel.addCycle(CycleRecipe.create());
      expect(viewModel.cycles.length, numInitialCycles);
    });

    test("Works properly while in incremental mode", () {
      var viewModel = ChartViewModelForTest();
      viewModel.toggleIncrementalMode();
      viewModel.toggleIncrementalMode();

      expect(viewModel.cycles.length, 0);
      expect(viewModel.charts.length, 1);

      viewModel.addCycle(CycleRecipe.create());
      expect(viewModel.cycles.length, 1);

      viewModel.addCycle(CycleRecipe.create());
      viewModel.addCycle(CycleRecipe.create());
      viewModel.addCycle(CycleRecipe.create());
      viewModel.addCycle(CycleRecipe.create());
      viewModel.addCycle(CycleRecipe.create());
      viewModel.addCycle(CycleRecipe.create());
      expect(viewModel.charts.length, 2);
    });
  });

  test("Update Error", () {
    var viewModel = ChartViewModelForTest();

    expect(viewModel.errorScenarios.length, 0);

    viewModel.updateErrors([ErrorScenario.forgetObservationOnFlow]);
    expect(viewModel.errorScenarios.length, 1);

    expect(viewModel.numUpdates, 1);
  });
}

Cycle fakeCycle(int numEntries) {
  List<ChartEntry> entries = List.generate(numEntries, (index) => ChartEntry(observationText: "0 AD"));
  return Cycle(index: 0, entries: entries);
}

class ChartViewModelForTest extends ChartViewModel {
  ChartViewModelForTest() : super(6) {
    incrementalMode = true;
  }

  void addFakeCycle(Cycle cycle) {
    cycles.add(cycle);
    charts = ChartViewModel.getCharts(cycles, 6);
  }

  int numUpdates = 0;

  @override
  void onChartChange() {
    numUpdates++;
  }
}

