import 'package:fmfu/logic/cycle_rendering.dart';
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
  final List<ChartEntry> entries;
  final Map<int, StickerWithText> corrections;

  Cycle(this.entries, this.corrections);

  List<int> getOffsets() {
    List<int> out = [];
    int nOffsets = (entries.length / 35).ceil();
    for (int i=0; i < nOffsets; i++) {
      out.add(35 * i);
    }
    return out;
  }

  static Cycle empty() {
    return Cycle([], {});
  }
}

class ChartEntry {
  String observationText;
  final RenderedObservation? renderedObservation;

  ChartEntry({required this.observationText, this.renderedObservation});
}