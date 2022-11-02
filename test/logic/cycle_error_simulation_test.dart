
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:test/test.dart';

void main() {
  group("Revert errors", () {
    test("Clears manual entries", () {
      var observations = [
        parseObservation("H"),     //0
        parseObservation("M"),     //1
        parseObservation("M"),     //2
        parseObservation("0 AD"),  //3
      ];
      var renderedObservations = renderObservations(observations, []);
      var entries = renderedObservations
          .map((observation) => ChartEntry(observationText: observation.observationText, renderedObservation: observation, manualSticker: StickerWithText(Sticker.red, null)))
          .toList();
      var correctedEntries = introduceErrors(entries, {});
      for (var entry in correctedEntries) {
        expect(entry.manualSticker, null);
      }
    });
    test("Restores observation text", () {
      var observations = [
        parseObservation("H"),     //0
        parseObservation("M"),     //1
        parseObservation("M"),     //2
        parseObservation("L 6C X1"),  //3
      ];
      var renderedObservations = renderObservations(observations, []);
      var entries = renderedObservations
          .map((observation) => ChartEntry(observationText: observation.observationText, renderedObservation: observation, manualSticker: StickerWithText(Sticker.red, null)))
          .toList();
      var correctedEntries = introduceErrors(entries, {ErrorScenario.forgetObservationOnFlow});
      expect(correctedEntries[3].observationText, "L");

      correctedEntries = introduceErrors(entries, {});
      expect(correctedEntries[3].observationText, "L 6C X1");
    });
  });

  group("Count of three", ()
  {
    test("for consecutive days of non-peak type mucus pre-peak", () {
      var observations = [
        parseObservation("H"),     //0
        parseObservation("M"),     //1
        parseObservation("M"),     //2
        parseObservation("0 AD"),  //3
        parseObservation("6C AD"), //4
        parseObservation("6C AD"), //5
        parseObservation("6C AD"), //6
        parseObservation("0 AD"),  //7
        parseObservation("0 AD"),  //8
        parseObservation("0 AD"),  //9
        parseObservation("0 AD"),  //10
      ];
      var renderedObservations = renderObservations(observations, []);
      var entries = renderedObservations
          .map((observation) => ChartEntry(observationText: observation.observationText, renderedObservation: observation,))
          .toList();
      var updatedEntries = introduceErrors(entries, {ErrorScenario.forgetD4});

      expect(updatedEntries[7].isCorrectSticker(), false);
      expect(updatedEntries[7].manualSticker!.sticker, Sticker.green);

      expect(updatedEntries[8].isCorrectSticker(), false);
      expect(updatedEntries[8].manualSticker!.sticker, Sticker.green);

      expect(updatedEntries[9].isCorrectSticker(), false);
      expect(updatedEntries[9].manualSticker!.sticker, Sticker.green);

      expect(updatedEntries[10].isCorrectSticker(), true);
    });
  });
}