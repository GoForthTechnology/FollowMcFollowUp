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
  final List<RenderedObservation> observations;
  final Map<int, StickerWithText> corrections;

  Cycle(this.observations, this.corrections);

  List<int> getOffsets() {
    List<int> out = [];
    int nOffsets = (observations.length / 35).ceil();
    for (int i=0; i < nOffsets; i++) {
      out.add(35 * i);
    }
    return out;
  }

  static Cycle empty() {
    return Cycle([], {});
  }
}