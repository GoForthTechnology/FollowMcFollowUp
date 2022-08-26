import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/stickers.dart';

class Chart {
  final List<Cycle> cycles;

  Chart(this.cycles);
}

class Cycle {
  final List<RenderedObservation> observations;
  final Map<int, StickerWithText> corrections;

  Cycle(this.observations, this.corrections);

  static Cycle empty() {
    return Cycle([], {});
  }
}