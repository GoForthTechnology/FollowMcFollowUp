
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:test/test.dart';

void main() {
  group("Follow Ups", () {
    test("Add invalid followup", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      expect(() => viewModel.addFollowUp(viewModel.latestStartOfCharting().addDays(1)), throwsException);
      expect(() => viewModel.addFollowUp(viewModel.earliestStartOfCharting().subtractDays(1)), throwsException);
    });

    test("Add duplicate followup", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      viewModel.addFollowUp(viewModel.startOfCharting().addDays(1));
      expect(() => viewModel.addFollowUp(viewModel.startOfCharting().addDays(1)), throwsException);
    });

    test("Current follow up number", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(2 * 365));
      expect(viewModel.currentFollowUpNumber(), null);

      for (int i=1; i<10; i++) {
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

      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.hasPreviousFollowUp(), false);

      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.hasPreviousFollowUp(), false);

      viewModel.goToNextFollowup();
      expect(viewModel.hasPreviousFollowUp(), true);

      viewModel.goToPreviousFollowup();
      expect(viewModel.hasPreviousFollowUp(), false);
    });

    test("Add several followups", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(365));
      expect(viewModel.currentFollowUpNumber(), null);
      expect(viewModel.currentFollowUpDate(), null);
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(14));

      // First follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(14));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(2*14));

      // Second follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(2*14));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(3*14));

      // Third follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(3*14));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(4*14));

      // Fourth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(4*14));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(4*14 + 1*28));

      // Fifth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(4*14 + 1*28));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(2*3*28));


      // Sixth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(2*3*28));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(3*3*28));

      // Seventh follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(3*3*28));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(4*3*28));

      // Eighth follow up
      viewModel.addFollowUp(viewModel.nextFollowUpDate());
      viewModel.goToNextFollowup();
      expect(viewModel.currentFollowUpNumber(), 8);
      expect(viewModel.currentFollowUpDate(), viewModel.startOfCharting().addDays(4*3*28));
      expect(viewModel.nextFollowUpDate(), viewModel.startOfCharting().addDays(5*3*28));
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
      expect(viewModel.latestStartOfCharting(), viewModel.earliestStartOfCharting());

      viewModel.cycles.add(fakeCycle(28));
      expect(viewModel.latestStartOfCharting(), viewModel.earliestStartOfCharting().addDays(28));
    });

    test("Set start of charting", () {
      ChartViewModel viewModel = ChartViewModelForTest();
      viewModel.cycles.add(fakeCycle(28));
      expect(viewModel.startOfCharting(), viewModel.earliestStartOfCharting());

      expect(() => viewModel.setStartOfCharting(viewModel.earliestStartOfCharting().subtractDays(1)), throwsException);
      expect(() => viewModel.setStartOfCharting(viewModel.earliestStartOfCharting().addDays(29)), throwsException);

      viewModel.setStartOfCharting(viewModel.earliestStartOfCharting().addDays(10));
      expect(viewModel.startOfCharting(), viewModel.earliestStartOfCharting().addDays(10));
    });
  });
}

Cycle fakeCycle(int numEntries) {
  List<ChartEntry> entries = List.generate(numEntries, (index) => ChartEntry(observationText: "0 AD"));
  return Cycle(index: 0, entries: entries);
}

class ChartViewModelForTest extends ChartViewModel {
  ChartViewModelForTest() : super(6);

  int numUpdates = 0;

  @override
  void onChartChange() {
    numUpdates++;
  }
}

