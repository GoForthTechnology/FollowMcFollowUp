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
  final Map<int, StickerWithText> corrections;
  bool canRerender = true;
  CycleStats cycleStats;

  Cycle(this.index, this.entries, this.corrections, {this.cycleStats = CycleStats.empty});

  List<int> getOffsets() {
    List<int> out = [];
    int nOffsets = (entries.length / 35).ceil();
    for (int i=0; i < nOffsets; i++) {
      out.add(35 * i);
    }
    return out;
  }

  static Cycle empty() {
    return Cycle(0, [], {});
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
    return CycleStats(mucusCycleScore: mucusCycleScore, lengthOfPostPeakPhase: null);
  }
}

class ChartEntry {
  final String observationText;
  final RenderedObservation? renderedObservation;
  final StickerWithText? manualSticker;

  ChartEntry({required this.observationText, this.renderedObservation, this.manualSticker});

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