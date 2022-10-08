
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:test/test.dart';

void main() {
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
      ];
      var renderedObservations = renderObservations(observations, []);
      expect(renderedObservations[7].getSticker(), Sticker.greenBaby);
      expect(renderedObservations[7].getStickerText(), "1");
    });
  });
  group("Basic Cycles", () {
    trainingCycles.forEach((key, cycle) => test(key, () => testTrainingCycle(cycle)));
  });
  group("Advanced Cycles", () {
    // TODO: re-enable
    //advancedCycles.forEach((key, cycle) => test(key, () => testTrainingCycle(cycle)));
  });
}

final trainingCycles = {
  "B1A": basicB1A,
  "B1B": basicB1B,
  "B1C": basicB1C,
  "B1D": basicB1D,
  "B1E": basicB1E,
  "B1F": basicB1F,
  "B7A": basicB7A,
};

final advancedCycles = {
  "Post Peak Yellow Stamps": advancedPostPeakYellowStamps,
  "Pre Peak Yellow Stamps": advancedPrePeakYellowStamps,
  "Breast Feeding Pre Peak Yellow Stamps": advancedBreastFeedingPrePeakYellowStamps,
};

void testTrainingCycle(TrainingCycle trainingCycle) {
  var expectations = List.of(trainingCycle.entries.values);
  trainingCycle.chartEntries().forEachIndexed((i, entry) {
    var expectation = expectations[i];
    var reason = "on day $i: ${entry.renderedObservation?.debugInfo()}";
    expect(entry.renderedObservation?.getSticker(), expectation.sticker(), reason: reason);
    expect(entry.renderedObservation?.getStickerText(), expectation.text() ?? "", reason: reason);
  });
}

TrainingCycle basicB1A = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L 0AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("2x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0AD"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0AD"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("0AD"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("6cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8kx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klAD"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klAD").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker("1"))

    .addEntry(TrainingEntry.forText("0AD"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0AD"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0AD"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2x1"), StickerExpectations.greenSticker());

TrainingCycle basicB1B = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L0AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("VL2x1"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("6cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8cad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klad").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker("1"))

    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker());

TrainingCycle basicB1C = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L0AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("2x2"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("2x2"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenBabySticker("3"))

    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10kad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10wlx2").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("1"))

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker());

TrainingCycle basicB1D = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("L0AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L8CX1"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10kx2"), StickerExpectations.whiteBabySticker(null))

    .addEntry(TrainingEntry.forText("10klad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cx1").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker("1"))
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.whiteBabySticker("2"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4x2"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2x1"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker());

TrainingCycle basicB1E = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("L0AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L2x2"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("10cx1").peakDay(), StickerExpectations.whiteBabySticker("P"))

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker(null))

    .addEntry(TrainingEntry.forText("8kx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cx1").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("2x2"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker());

TrainingCycle basicB1F = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L0AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8kx2").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker("1"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("2"))

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("vl10kx2").unusualBleeding(), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("vl0ad").unusualBleeding(), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("2"))

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("2x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4x2"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker());

TrainingCycle basicB7A = TrainingCycle.create()
    .addEntry(TrainingEntry.forText("L2AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L2AD"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("2AD").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("2AD"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("2AD").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("2AD").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("2AD"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8kad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cx1").peakDay(), StickerExpectations.whiteBabySticker("P"))

    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("4ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("10cklx1"), StickerExpectations.whiteBabySticker(null))

    .addEntry(TrainingEntry.forText("10ckad").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("2x3").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("0ad").intercourse(), StickerExpectations.greenSticker().withIntercourse())

    .addEntry(TrainingEntry.forText("4x1").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker());

TrainingCycle advancedPostPeakYellowStamps = TrainingCycle
    .create(instructions: [Instruction.k2])
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("H"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L2ad"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("VL0ad"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("0ad").intercourse(), StickerExpectations.greenSticker().withIntercourse())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad").intercourse(), StickerExpectations.greenSticker().withIntercourse())

    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cgx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cklx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10cklad"), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("4x2"), StickerExpectations.greenBabySticker("1"))

    .addEntry(TrainingEntry.forText("10cx1").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.yellowBabySticker("1"))
    .addEntry(TrainingEntry.forText("8cgx2"), StickerExpectations.yellowBabySticker("2"))
    .addEntry(TrainingEntry.forText("8gyx1"), StickerExpectations.yellowBabySticker("3"))
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.yellowSticker())

    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx2"), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("4ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("0ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx1"), StickerExpectations.yellowSticker());

// From "Use of Pre-Peak Yellow Stamps in Regular Cycles (21 to 38 Days)
// with a Mucus Cycle more thn 8 Days"
TrainingCycle advancedPrePeakYellowStamps = TrainingCycle
    .create(instructions: [Instruction.k1])
    .addEntry(TrainingEntry.forText("L2ad"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("M"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L6cx1"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("L6cx2"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("VL6cx2"), StickerExpectations.redSticker())
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())

    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8kx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10kx3"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10klx1"), StickerExpectations.whiteBabySticker(null))

    .addEntry(TrainingEntry.forText("10klx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10wlad"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("10wlad").peakDay(), StickerExpectations.whiteBabySticker("P"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("1"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("4x1"), StickerExpectations.greenBabySticker("3"))
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker())

    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("2ad"), StickerExpectations.greenSticker());

// From Book 2, figure 6-3: The use of pre-Peak yellow stamps in a women who is breastfeeding
TrainingCycle advancedBreastFeedingPrePeakYellowStamps = TrainingCycle
    .create(instructions: [Instruction.k1])
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6gcx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8gyx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())

// Starting at 7
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cad").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("0ad").essentiallyTheSame(), StickerExpectations.greenSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())

// Starting at 14
    .addEntry(TrainingEntry.forText("8gyx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8kx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("6cx1"), StickerExpectations.yellowBabySticker("1"))
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowBabySticker("2"))
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowBabySticker("3"))
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())

// Starting at 21
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("10kad").pointOfChange(), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowBabySticker("1"))
    .addEntry(TrainingEntry.forText("0ad").essentiallyTheSame(), StickerExpectations.greenBabySticker("2"))
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowBabySticker("3"))
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())

// Starting at 28
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cgx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())

// Starting at 35
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cad").pointOfChange(), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8kx2"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("8kx1"), StickerExpectations.whiteBabySticker(null))
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowBabySticker("1"))

// Starting at 42
    .addEntry(TrainingEntry.forText("6cx2").essentiallyTheSame(), StickerExpectations.yellowBabySticker("2"))
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowBabySticker("3"))
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("6cx1").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker())
    .addEntry(TrainingEntry.forText("8cx2").essentiallyTheSame(), StickerExpectations.yellowSticker());

class TrainingCycle {
  final List<Instruction> activeInstructions;
  final LinkedHashMap<TrainingEntry, StickerExpectations> entries = LinkedHashMap();

  TrainingCycle({this.activeInstructions = const []});

  static TrainingCycle create({List<Instruction> instructions = const []}) {
    return TrainingCycle(activeInstructions: instructions);
  }

  TrainingCycle addEntry(TrainingEntry entry, StickerExpectations expectations) {
    entries[entry] = expectations;
    return this;
  }

  List<ChartEntry> chartEntries() {
    var observations = entries.keys
        .map((trainingEntry) {
          var observation = parseObservation(trainingEntry._observationText);
          return Observation(
            flow: observation.flow,
            dischargeSummary: observation.dischargeSummary,
            essentiallyTheSame: trainingEntry._isEssentiallyTheSame,
          );
        })
        .toList();
    return renderObservations(observations, activeInstructions)
        .map((o) => ChartEntry.fromRenderedObservation(o))
        .toList();
  }
}

class TrainingEntry {
  final String _observationText;
  bool _peakDay = false;
  bool _intercourse = false;
  bool _pointOfChange = false;
  bool _unusualBleeding = false;
  bool _isEssentiallyTheSame = false;
  bool _uncertain = false;

  TrainingEntry(this._observationText);

  static TrainingEntry forText(String observation) {
    return TrainingEntry(observation);
  }

  TrainingEntry peakDay() {
    _peakDay = true;
    return this;
  }

  TrainingEntry intercourse() {
    _intercourse = true;
    return this;
  }

  TrainingEntry pointOfChange() {
    _pointOfChange = true;
    return this;
  }

  TrainingEntry unusualBleeding() {
    _unusualBleeding = true;
    return this;
  }

  TrainingEntry essentiallyTheSame() {
    _isEssentiallyTheSame = true;
    return this;
  }

  TrainingEntry uncertain() {
    _uncertain = true;
    return this;
  }
}

class StickerExpectations {
  final StickerWithText stickerWithText;
  bool shouldHaveIntercourse = false;

  StickerExpectations(this.stickerWithText);

  Sticker sticker() {
    return stickerWithText.sticker;
  }

  String? text() {
    return stickerWithText.text;
  }

  static StickerExpectations redSticker() {
    return StickerExpectations(StickerWithText(Sticker.red, null));
  }

  static StickerExpectations greenSticker() {
    return StickerExpectations(StickerWithText(Sticker.green, null));
  }

  static StickerExpectations greenBabySticker(String? text) {
    return StickerExpectations(StickerWithText(Sticker.greenBaby, text));
  }

  static StickerExpectations yellowBabySticker(String? text) {
    return StickerExpectations(StickerWithText(Sticker.yellowBaby, text));
  }

  static StickerExpectations yellowSticker() {
    return StickerExpectations(StickerWithText(Sticker.yellow, null));
  }

  static StickerExpectations whiteBabySticker(String? text) {
    return StickerExpectations(StickerWithText(Sticker.whiteBaby, text));
  }

  static StickerExpectations greySticker() {
    return StickerExpectations(StickerWithText(Sticker.grey, null));
  }

  StickerExpectations withIntercourse() {
    shouldHaveIntercourse = true;
    return this;
  }
}

