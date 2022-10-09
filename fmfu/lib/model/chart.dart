import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/stickers.dart';

class Chart {
  final List<CycleSlice> cycles;

  Chart(this.cycles);
}

class CycleSlice {
  final Cycle? cycle;
  final int offset;

  CycleSlice(this.cycle, this.offset);
}

class Cycle {
  final int index;
  final List<ChartEntry> entries;
  final Map<int, StickerWithText> stickerCorrections;
  final Map<int, String> observationCorrections;
  bool canRerender = true;
  CycleStats cycleStats;

  Cycle({required this.index, required this.entries, this.stickerCorrections = const {}, this.observationCorrections = const {}, this.cycleStats = CycleStats.empty});

  List<int> getOffsets() {
    List<int> out = [];
    int nOffsets = (entries.length / 35).ceil();
    for (int i=0; i < nOffsets; i++) {
      out.add(35 * i);
    }
    return out;
  }

  static Cycle empty() {
    return Cycle(index: 0, entries: [], stickerCorrections: {}, observationCorrections: {});
  }
}

class CycleStats {
  final double? mucusCycleScore;
  final int? lengthOfPostPeakPhase;

  static const CycleStats empty = CycleStats(mucusCycleScore: null, lengthOfPostPeakPhase: null);

  const CycleStats({required this.mucusCycleScore, required this.lengthOfPostPeakPhase});

  CycleStats setMucusCycleScore(double? score) {
    return CycleStats(mucusCycleScore: score, lengthOfPostPeakPhase: lengthOfPostPeakPhase);
  }

  CycleStats setLengthOfPostPeakPhase(int? length) {
    return CycleStats(mucusCycleScore: mucusCycleScore, lengthOfPostPeakPhase: length);
  }
}

class ChartEntry {
  final String observationText;
  final RenderedObservation? renderedObservation;
  final StickerWithText? manualSticker;

  ChartEntry({required this.observationText, this.renderedObservation, this.manualSticker});

  static ChartEntry fromRenderedObservation(RenderedObservation renderedObservation) {
    return ChartEntry(observationText: renderedObservation.observationText, renderedObservation: renderedObservation);
  }

  bool isValidObservation() {
    try {
      parseObservation(observationText);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isCorrectSticker() {
    if (manualSticker == null || renderedObservation == null) {
      return true;
    }
    var correctSticker = StickerWithText(renderedObservation!.getSticker(), renderedObservation!.getStickerText());
    return manualSticker == correctSticker;
  }

  bool hasErrors() {
    return !isCorrectSticker() || !isValidObservation();
  }
}