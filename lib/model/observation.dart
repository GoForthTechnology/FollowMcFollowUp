import 'package:collection/collection.dart';

class Observation {
  final Flow? flow;
  final DischargeSummary? dischargeSummary;
  final bool? essentiallyTheSame;

  Observation({this.flow, this.dischargeSummary, this.essentiallyTheSame});

  @override
  String toString() {
    List<String> parts = [];
    if (flow != null) {
      // New line is for the "new guidance" from the institute (c.a. 2019)
      parts.add("${flow!.code}\n");
    }
    if (dischargeSummary != null) {
      parts.add(dischargeSummary.toString());
    }
    return parts.join(" ");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Observation
        && other.flow == flow
        && other.dischargeSummary == dischargeSummary
        && other.essentiallyTheSame == essentiallyTheSame
    ;
  }

  @override
  int get hashCode => Object.hash(flow, dischargeSummary, essentiallyTheSame);

  bool get hasMucus {
    return dischargeSummary == null ? false : dischargeSummary!.hasMucus;
  }

  bool get hasPeakTypeMucus {
    return dischargeSummary == null ? false : dischargeSummary!.hasPeakTypeMucus;
  }

  bool get hasNonPeakTypeMucus {
    return dischargeSummary == null ? false : dischargeSummary!.hasNonPeakTypeMucus;
  }

  bool get hasBleeding {
    if (flow != null) {
      return true;
    }
    return dischargeSummary != null && dischargeSummary!.hasBleeding;
  }
}

enum Flow {
  heavy,
  medium,
  light,
  veryLight;

  static Flow? fromCode(String code) {
    switch (code) {
      case "H":
        return Flow.heavy;
      case "M":
        return Flow.medium;
      case "L":
        return Flow.light;
      case "VL":
        return Flow.veryLight;
    }
    return null;
  }

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

  bool get requiresDischargeSummary {
    switch (this) {
      case Flow.heavy:
      case Flow.medium:
        return false;
      case Flow.light:
      case Flow.veryLight:
        return true;
    }
  }
}

class DischargeSummary {
  final DischargeType? dischargeType;
  final DischargeFrequency dischargeFrequency;
  final List<DischargeDescriptor> dischargeDescriptors;

  DischargeSummary({required this.dischargeType, required this.dischargeFrequency, this.dischargeDescriptors = const []});

  @override
  String toString() {
    return "${dischargeType?.code ?? ""}${dischargeDescriptors.join("")} ${dischargeFrequency.code}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is DischargeSummary
        && other.dischargeType == dischargeType
        && other.dischargeFrequency == dischargeFrequency
        && const ListEquality().equals(other.dischargeDescriptors, dischargeDescriptors);
  }

  @override
  int get hashCode => Object.hash(dischargeType, dischargeFrequency, dischargeDescriptors);


  bool get hasBleeding {
    for (var dischargeDescriptor in dischargeDescriptors) {
      if (dischargeDescriptor.indicatesBleeding) {
        return true;
      }
    }
    return false;
  }

  bool get hasPeakTypeMucus {
    if (dischargeType == null) {
      return false;
    }
    if (dischargeType!.isPeakType) {
      return true;
    }
    for (var descriptor in dischargeDescriptors) {
      if (descriptor.indicatesPeakType) {
        return true;
      }
    }
    return false;
  }

  bool get hasNonPeakTypeMucus {
    return hasMucus && !hasPeakTypeMucus;
  }

  bool get hasMucus {
    return dischargeType?.hasMucus ?? false;
  }

}

enum DischargeType with DischargeComponent {
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

  @override
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

  bool get hasMucus {
    switch (this) {
      case DischargeType.dry:
      case DischargeType.wetWithoutLubrication:
      case DischargeType.dampWithoutLubrication:
      case DischargeType.shinyWithoutLubrication:
        return false;
      case DischargeType.sticky:
      case DischargeType.tacky:
      case DischargeType.wetWithLubrication:
      case DischargeType.dampWithLubrication:
      case DischargeType.shinyWithLubrication:
      case DischargeType.stretchy:
        return true;
    }
  }

  bool get isPeakType {
    switch (this) {
      case DischargeType.dry:
      case DischargeType.wetWithoutLubrication:
      case DischargeType.dampWithoutLubrication:
      case DischargeType.shinyWithoutLubrication:
      case DischargeType.sticky:
      case DischargeType.tacky:
        return false;
      case DischargeType.wetWithLubrication:
      case DischargeType.dampWithLubrication:
      case DischargeType.shinyWithLubrication:
      case DischargeType.stretchy:
        return true;
    }
  }

  bool get requiresDescriptors {
    switch (this) {
      case DischargeType.dry:
      case DischargeType.wetWithoutLubrication:
      case DischargeType.dampWithoutLubrication:
      case DischargeType.shinyWithoutLubrication:
      case DischargeType.wetWithLubrication:
      case DischargeType.dampWithLubrication:
      case DischargeType.shinyWithLubrication:
        return false;
      case DischargeType.sticky:
      case DischargeType.tacky:
      case DischargeType.stretchy:
        return true;
    }
  }
}

enum DischargeFrequency with DischargeComponent {
  once,
  twice,
  thrice,
  allDay;

  @override
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

abstract class DischargeComponent {
  String get code;
}

enum DischargeDescriptor with DischargeComponent {
  brown,
  red,
  cloudyClear, // It's important this comes before "cloudy" for parsing
  cloudy,
  gummy,
  clear,
  lubricative,
  pasty,
  yellow;

  @override
  String get code {
    switch (this) {
      case DischargeDescriptor.brown:
        return "B";
      case DischargeDescriptor.red:
        return "R";
      case DischargeDescriptor.cloudy:
        return "C";
      case DischargeDescriptor.cloudyClear:
        return "C/K";
      case DischargeDescriptor.gummy:
        return "G";
      case DischargeDescriptor.clear:
        return "K";
      case DischargeDescriptor.lubricative:
        return "L";
      case DischargeDescriptor.pasty:
        return "P";
      case DischargeDescriptor.yellow:
        return "Y";
    }
  }

  bool get requiresColor {
    switch (this) {
      case DischargeDescriptor.pasty:
      case DischargeDescriptor.gummy:
        return true;
      case DischargeDescriptor.brown:
      case DischargeDescriptor.red:
      case DischargeDescriptor.cloudyClear:
      case DischargeDescriptor.cloudy:
      case DischargeDescriptor.clear:
      case DischargeDescriptor.lubricative:
      case DischargeDescriptor.yellow:
        return false;
    }
  }

  bool get isColor {
    switch (this) {
      case DischargeDescriptor.pasty:
      case DischargeDescriptor.gummy:
      case DischargeDescriptor.lubricative:
        return false;
      case DischargeDescriptor.brown:
      case DischargeDescriptor.red:
      case DischargeDescriptor.cloudyClear:
      case DischargeDescriptor.cloudy:
      case DischargeDescriptor.clear:
      case DischargeDescriptor.yellow:
        return true;
    }
  }

  bool get indicatesBleeding {
    switch (this) {
      case DischargeDescriptor.brown:
      case DischargeDescriptor.red:
        return true;
      case DischargeDescriptor.cloudy:
      case DischargeDescriptor.cloudyClear:
      case DischargeDescriptor.gummy:
      case DischargeDescriptor.clear:
      case DischargeDescriptor.lubricative:
      case DischargeDescriptor.pasty:
      case DischargeDescriptor.yellow:
        return false;
    }
  }

  bool get indicatesPeakType {
    switch (this) {
      case DischargeDescriptor.lubricative:
      case DischargeDescriptor.clear:
      case DischargeDescriptor.cloudyClear:
        return true;
      case DischargeDescriptor.brown:
      case DischargeDescriptor.red:
      case DischargeDescriptor.cloudy:
      case DischargeDescriptor.gummy:
      case DischargeDescriptor.pasty:
      case DischargeDescriptor.yellow:
        return false;
    }
  }

  @override
  String toString() {
    return code;
  }
}
