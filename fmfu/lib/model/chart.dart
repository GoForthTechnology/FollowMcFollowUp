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
  final index;
  final List<ChartEntry> entries;
  final Map<int, StickerWithText> corrections;
  bool canRerender = true;

  Cycle(this.index, this.entries, this.corrections);

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

class ChartEntry {
  final String observationText;
  final RenderedObservation? renderedObservation;

  ChartEntry({required this.observationText, this.renderedObservation});

  bool isValidObservation() {
    try {
      parseObservation(observationText);
      return true;
    } catch (e) {
      return false;
    }
  }
}