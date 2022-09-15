
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:test/test.dart';

TrainingCycle basicB1A = TrainingCycle
    .withInstructions()
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

 TrainingCycle basicB1B = TrainingCycle
    .withInstructions()
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

 TrainingCycle basicB1C = TrainingCycle
    .withInstructions()
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

 TrainingCycle basicB1D = TrainingCycle
    .withInstructions()
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

TrainingCycle basicB1E = TrainingCycle
    .withInstructions()
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

TrainingCycle basicB1F = TrainingCycle
    .withInstructions()
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
    test("B1A", () {
      testTrainingCycle(basicB1A);
    });
    test("B1B", () {
      testTrainingCycle(basicB1B);
    });
    test("B1C", () {
      testTrainingCycle(basicB1C);
    });
    test("B1D", () {
      testTrainingCycle(basicB1D);
    });
    test("B1E", () {
      testTrainingCycle(basicB1E);
    });
    test("B1F", () {
      testTrainingCycle(basicB1F);
    });
  });
}

void testTrainingCycle(TrainingCycle trainingCycle) {
  var expectations = List.of(trainingCycle.entries.values);
  trainingCycle.chartEntries().forEachIndexed((i, entry) {
    var expectation = expectations[i];
    expect(entry.renderedObservation?.getSticker(), expectation.sticker(), reason: "on day $i");
    expect(entry.renderedObservation?.getStickerText(), expectation.text() ?? "", reason: "on day $i");
  });
}

class TrainingCycle {
  final LinkedHashMap<TrainingEntry, StickerExpectations> entries = LinkedHashMap();

  static TrainingCycle withInstructions() {
    return TrainingCycle();
  }

  TrainingCycle addEntry(TrainingEntry entry, StickerExpectations expectations) {
    entries[entry] = expectations;
    return this;
  }

  List<ChartEntry> chartEntries() {
    var observations = entries.keys
        .map((trainingEntry) => parseObservation(trainingEntry._observationText))
        .toList();
    return renderObservations(observations, [])
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

