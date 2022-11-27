import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart.g.dart';

class Chart {
  final List<CycleSlice> cycles;

  Chart(this.cycles);
}

class CycleSlice {
  final Cycle? cycle;
  final int offset;

  CycleSlice(this.cycle, this.offset);
}

@JsonSerializable(explicitToJson: true)
class Cycle {
  final int index;
  final List<ChartEntry> entries;
  final Map<int, StickerWithText> stickerCorrections;
  final Map<int, String> observationCorrections;
  bool canRerender = true;
  CycleStats cycleStats;

  Cycle({
    required this.index,
    required this.entries,
    required this.stickerCorrections,
    required this.observationCorrections,
    this.cycleStats = CycleStats.empty,
  });

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

  factory Cycle.fromJson(Map<String, dynamic> json) => _$CycleFromJson(json);
  Map<String, dynamic> toJson() => _$CycleToJson(this);
}

@JsonSerializable(explicitToJson: true)
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

  factory CycleStats.fromJson(Map<String, dynamic> json) => _$CycleStatsFromJson(json);
  Map<String, dynamic> toJson() => _$CycleStatsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChartEntry {
  final String observationText;
  final String additionalText;
  final RenderedObservation? renderedObservation;
  final StickerWithText? manualSticker;

  ChartEntry({required this.observationText, required this.additionalText, this.renderedObservation, this.manualSticker});

  static ChartEntry fromRenderedObservation(RenderedObservation renderedObservation) {
    return ChartEntry(
      observationText: renderedObservation.observationText,
      additionalText: renderedObservation.additionalText(),
      renderedObservation: renderedObservation,
    );
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

  factory ChartEntry.fromJson(Map<String, dynamic> json) => _$ChartEntryFromJson(json);
  Map<String, dynamic> toJson() => _$ChartEntryToJson(this);
}