class Observation {
  final Flow? flow;
  final DischargeSummary? dischargeSummary;

  Observation(this.flow, this.dischargeSummary);

  @override
  String toString() {
    List<String> parts = [];
    if (flow != null) {
      parts.add(flow!.code);
    }
    if (dischargeSummary != null) {
      parts.add(dischargeSummary.toString());
    }
    return parts.join(" ");
  }
}

enum Flow {
  heavy,
  medium,
  light,
  veryLight;

  String get code {
    switch (this) {
      case Flow.heavy:
        return "H";
      case Flow.medium:
        return "M";
      case Flow.light:
        return "L";
      case Flow.veryLight:
        return "VL";
    }
  }
}

class DischargeSummary {
  final DischargeType dischargeType;
  final DischargeFrequency dischargeFrequency;

  DischargeSummary(this.dischargeType, this.dischargeFrequency);

  @override
  String toString() {
    return "${dischargeType.code}${dischargeFrequency.code}";
  }
}

enum DischargeType {
  dry,
  wetWithoutLubrication,
  dampWithoutLubrication,
  shinyWithoutLubrication,
  sticky,
  tacky,
  wetWithLubrication,
  dampWithLubrication,
  shinyWithLubrication,
  stretchy;

  String get code {
    switch (this) {
      case DischargeType.dry:
        return "0";
      case DischargeType.wetWithoutLubrication:
        return "2W";
      case DischargeType.dampWithoutLubrication:
        return "2";
      case DischargeType.shinyWithoutLubrication:
        return "4";
      case DischargeType.sticky:
        return "6";
      case DischargeType.tacky:
        return "8";
      case DischargeType.wetWithLubrication:
        return "10WL";
      case DischargeType.dampWithLubrication:
        return "10DL";
      case DischargeType.shinyWithLubrication:
        return "10SL";
      case DischargeType.stretchy:
        return "10";
    }
  }
}

enum DischargeFrequency {
  once,
  twice,
  thrice,
  allDay;

  String get code {
    switch (this) {
      case DischargeFrequency.once:
        return "X1";
      case DischargeFrequency.twice:
        return "X2";
      case DischargeFrequency.thrice:
        return "X3";
      case DischargeFrequency.allDay:
        return "AD";
    }
  }

}
