

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/model/instructions.dart';


List<RenderedObservation> renderObservations(List<Observation> observations, List<Instruction> activeInstructions) {
  int daysOfFlow = 0;
  int consecutiveDaysOfNonPeakMucus = 0;
  int consecutiveDaysOfPeakMucus = 0;
  CountsOfThree countsOfThree = CountsOfThree();

  List<RenderedObservation> renderedObservations = [];
  for (int i=0; i < observations.length; i++) {
    var observation = observations[i];
    var isPostPeak = countsOfThree.getCount(CountOfThreeReason.peakDay, i) > 0;

    if (observation.flow != null) {
      daysOfFlow++;
    }
    bool inFlow = daysOfFlow == i+1;
    bool hasUnusualBleeding = observation.hasBleeding && !inFlow;
    if (hasUnusualBleeding) {
      countsOfThree.registerCountStart(CountOfThreeReason.unusualBleeding, i);
    }

    if (observation.hasPeakTypeMucus) {
      consecutiveDaysOfPeakMucus++;
    } else {
      consecutiveDaysOfPeakMucus = 0;
    }
    if (observation.hasNonPeakTypeMucus) {
      consecutiveDaysOfNonPeakMucus++;
    } else {
      consecutiveDaysOfNonPeakMucus = 0;
    }

    if (!observation.hasNonPeakTypeMucus) {
      if (consecutiveDaysOfNonPeakMucus >= 3) {
        countsOfThree.registerCountStart(CountOfThreeReason.consecutiveDaysOfNonPeakMucus, i);
      }
      consecutiveDaysOfNonPeakMucus = 0;
    } else {
      consecutiveDaysOfNonPeakMucus++;
    }

    if (observation.hasPeakTypeMucus) {
      countsOfThree.registerCountStart(CountOfThreeReason.singleDayOfPeakMucus, i);
    }

    List<Instruction> fertilityReasons = [];
    if (inFlow) {
      fertilityReasons.add(Instruction.d1);
    }
    // NOTE: This should really check !isPostPeak && observation.hasMucus but...
    if (observation.hasMucus || countsOfThree.inCountOfThree(CountOfThreeReason.peakDay, i)) {
      fertilityReasons.add(Instruction.d2);
    }
    if (!isPostPeak && (consecutiveDaysOfNonPeakMucus > 0 && consecutiveDaysOfNonPeakMucus < 3)) {
      fertilityReasons.add(Instruction.d3);
    }
    if (!isPostPeak && consecutiveDaysOfNonPeakMucus >= 3) {
      fertilityReasons.add(Instruction.d4);
    }
    if (!isPostPeak && observation.hasPeakTypeMucus) {
      fertilityReasons.add(Instruction.d5);
    }
    if (hasUnusualBleeding || countsOfThree.inCountOfThree(CountOfThreeReason.unusualBleeding, i)) {
      fertilityReasons.add(Instruction.d6);
    }

    bool hasAnotherEntry = i+1 < observations.length;
    bool isPeakDay = hasAnotherEntry && (consecutiveDaysOfPeakMucus > 0 && !observations[i+1].hasPeakTypeMucus);
    if (isPeakDay) {
      countsOfThree.registerCountStart(CountOfThreeReason.peakDay, i);
    }
    List<Instruction> infertilityReasons = [];
    bool hasSpecialInstructions = false;
    if (activeInstructions.contains(Instruction.k2) && isPostPeak) {
      infertilityReasons.add(Instruction.k2);
      // I REALLY don't like how this is done...
      if (!countsOfThree.inCountOfThree(CountOfThreeReason.peakDay, i)) {
        fertilityReasons.remove(Instruction.d2);
      }
    }

    renderedObservations.add(RenderedObservation(
        observation.toString(),
        countsOfThree.getCountOfThree(i),
        isPeakDay,
        observation.hasBleeding,
        observation.hasMucus,
        inFlow,
        hasSpecialInstructions,
        fertilityReasons,
        infertilityReasons,
        observation.essentiallyTheSame,
    ));
  }
  return renderedObservations;
}

class RenderedObservation {
  final String observationText;
  final int countOfThree;
  final bool isPeakDay;
  final bool hasBleeding;
  final bool hasMucus;
  final bool inFlow;
  final bool hasSpecialInstructions;
  final bool? essentiallyTheSame;
  final List<Instruction> fertilityReasons;
  final List<Instruction> infertilityReasons;

  RenderedObservation(this.observationText, this.countOfThree, this.isPeakDay, this.hasBleeding, this.hasMucus, this.inFlow, this.hasSpecialInstructions, this.fertilityReasons, this.infertilityReasons, this.essentiallyTheSame);

  String getObservationText() {
    String text = observationText;
    if (essentiallyTheSame == null) {
      return text;
    }
    if (essentiallyTheSame!) {
      return "$text\nY";
    }
    return "$text\nN";
  }

  String getStickerText() {
    if (hasBleeding) {
      return "";
    }
    if (isPeakDay) {
      return "P";
    }
    if (countOfThree > 0) {
      return countOfThree.toString();
    }
    if (fertilityReasons.isEmpty) {
      return "";
    }
    if (countOfThree > 0) {
      return "$countOfThree";
    }
    return "";
  }

  static const Color _lightGreen = Color(0xFFE2FFCC);

  Sticker getSticker() {
    bool isFertile = fertilityReasons.isNotEmpty;
    bool hasInfertilityReasons = infertilityReasons.isNotEmpty;

    if (inFlow || isFertile) {
      if (hasBleeding) {
        return Sticker.red;
      } else {
        if (hasMucus) {
          return hasInfertilityReasons ? Sticker.yellowBaby : Sticker.whiteBaby;
        } else {
          return Sticker.greenBaby;
        }
      }
    } else {
      return hasMucus ? Sticker.yellow : Sticker.green;
    }
  }
}

enum CountOfThreeReason {
  unusualBleeding,
  peakDay,
  consecutiveDaysOfNonPeakMucus,
  singleDayOfPeakMucus,
  pointOfChange,
  uncertain
}

class CountsOfThree {
  final Map<CountOfThreeReason, int> _countStarts = {};

  void registerCountStart(CountOfThreeReason reason, int i) {
    _countStarts[reason] = i;
  }

  int getCountOfThree(int i) {
    int out = 0;
    for (var index in _countStarts.values) {
      var count = i - index;
      if (count <= 3 && count > out) {
        out = count;
      }
    }
    return out;
  }

  int getCount(CountOfThreeReason reason, int i) {
    int? countStart = _countStarts[reason];
    if (countStart == null) {
      return 0;
    }
    return i - countStart;
  }

  bool inCountOfThree(CountOfThreeReason reason, int i) {
    int? count = getCount(reason, i);
    return count != null && count > 0 && count <= 3;
  }
}
