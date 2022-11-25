
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:time_machine/time_machine.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rendered_observation.g.dart';

@JsonSerializable(explicitToJson: true)
@LocalDateJsonConverter()
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
  final DebugInfo debugInfo;
  final LocalDate? date;

  RenderedObservation(this.observationText, this.countOfThree, this.isPeakDay, this.hasBleeding, this.hasMucus, this.inFlow, this.fertilityReasons, this.infertilityReasons, this.essentiallyTheSame, this.debugInfo, this.date);

  static RenderedObservation blank(LocalDate date) {
    return RenderedObservation("", 0, false, false, false, false, [], [], null, const DebugInfo(), date);
  }

  String debugString() {
    return "{debugInfo: $debugInfo, essentiallyTheSame: $essentiallyTheSame, fertilityReasons: $fertilityReasons, infertilityReasons: $infertilityReasons}";
  }

  String additionalText() {
    if (essentiallyTheSame == null) {
      return "";
    }
    if (essentiallyTheSame!) {
      return "Y";
    }
    return "N";
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

  factory RenderedObservation.fromJson(Map<String, dynamic> json) => _$RenderedObservationFromJson(json);
  Map<String, dynamic> toJson() => _$RenderedObservationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DebugInfo {
  final CountOfThreeReason? countOfThreeReason;

  const DebugInfo({this.countOfThreeReason});

  @override
  String toString() {
    return "{countOfThreeReason: $countOfThreeReason}";
  }

  factory DebugInfo.fromJson(Map<String, dynamic> json) => _$DebugInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DebugInfoToJson(this);
}

enum CountOfThreeReason {
  unusualBleeding,
  peakDay,
  consecutiveDaysOfNonPeakMucus,
  singleDayOfPeakMucus,
  pointOfChange,
  uncertain
}

class LocalDateJsonConverter extends JsonConverter<LocalDate, int> {
  const LocalDateJsonConverter();

  @override
  LocalDate fromJson(int json) {
    return LocalDate.fromEpochDay(json);
  }

  @override
  int toJson(LocalDate object) {
    return object.epochDay;
  }
}
