
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:time_machine/time_machine.dart';

class RenderedObservation {
  final String observationText;
  final int countOfThree;
  final bool isPeakDay;
  final bool hasBleeding;
  final bool hasMucus;
  final bool inFlow;
  final bool? essentiallyTheSame;
  final List<Instruction> fertilityReasons;
  final List<Instruction> infertilityReasons;
  final DebugInfo _debugInfo;
  final LocalDate? date;

  RenderedObservation(this.observationText, this.countOfThree, this.isPeakDay, this.hasBleeding, this.hasMucus, this.inFlow, this.fertilityReasons, this.infertilityReasons, this.essentiallyTheSame, this._debugInfo, this.date);

  String debugInfo() {
    return "{debugInfo: $_debugInfo, essentiallyTheSame: $essentiallyTheSame, fertilityReasons: $fertilityReasons, infertilityReasons: $infertilityReasons}";
  }

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

class DebugInfo {
  final CountOfThreeReason? countOfThreeReason;

  const DebugInfo({this.countOfThreeReason});

  @override
  String toString() {
    return "{countOfThreeReason: $countOfThreeReason}";
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
