import 'package:fmfu/model/observation.dart';
import 'package:collection/collection.dart';


Observation parseObservation(String input) {
  input = input.replaceAll(" ", "");

  Flow? flow = _getFlow(input);
  DischargeSummary? dischargeSummary;
  try {
    if (flow != null) {
      input = consumePrefix(flow.code, input);

      if (flow.requiresDischargeSummary) {
        if (input.isEmpty) {
          throw Exception("Flow $flow requires a discharge summary");
        }
        dischargeSummary = _getDischargeSummary(input);
      } else {
        if (input.isNotEmpty) {
          throw Exception("Flow $flow should not have a discharge summary");
        }
      }
    } else {
      dischargeSummary = _getDischargeSummary(input);
    }
    return Observation(flow: flow, dischargeSummary: dischargeSummary);
  } catch (e) {
    throw Exception("Could not parse $input. Reason: $e");
  }
}

DischargeSummary _getDischargeSummary(String input) {
  var dischargeType = _getDischargeType(input);
  input = consumePrefix(dischargeType.code, input);

  var dischargeDescriptors = _getDischargeDescriptors(input);
  for (var descriptor in dischargeDescriptors) {
    input = consumePrefix(descriptor.code, input);
  }

  if (dischargeType.requiresDescriptors && !dischargeDescriptors.isNotEmpty) {
    throw Exception("$dischargeType should not have descriptors");
  }

  if (!dischargeType.requiresDescriptors && dischargeDescriptors.isNotEmpty) {
    throw Exception("$dischargeType requires descriptors");
  }

  DischargeDescriptor? descriptorRequiringColor = dischargeDescriptors.where((d) => d.requiresColor).firstOrNull;
  bool hasColor = dischargeDescriptors.where((d) => d.isColor).isNotEmpty;
  if (descriptorRequiringColor != null && !hasColor) {
    throw Exception("$descriptorRequiringColor requires a color");
  }

  var dischargeFrequency = _getDischargeFrequency(input);
  input = consumePrefix(dischargeFrequency.code, input);

  var dischargeSummary = DischargeSummary(
    dischargeType: dischargeType,
    dischargeFrequency: dischargeFrequency,
    dischargeDescriptors: dischargeDescriptors,
  );

  input = consumePrefix(dischargeSummary.toString().replaceAll(" ", ""), input);
  if (input.isNotEmpty) {
    throw Exception("Nothing should follow discharge summary. Extra text: $input");
  }

  return dischargeSummary;
}

DischargeFrequency _getDischargeFrequency(String input) {
  for (var dischargeFrequency in DischargeFrequency.values) {
    if (input.startsWith(dischargeFrequency.code)) {
      return dischargeFrequency;
    }
  }
  throw Exception("$input does not have a discharge frequency");
}

List<DischargeDescriptor> _getDischargeDescriptors(String input) {
  List<DischargeDescriptor> descriptors = [];
  _consumeDescriptor(input, descriptors);
  Set<DischargeDescriptor> deduped = Set.from(descriptors);
  if (descriptors.length != deduped.length) {
    throw Exception("Duplicate descriptors not allowed");
  }
  return descriptors;
}

String _consumeDescriptor(String input, List<DischargeDescriptor> descriptors) {
  for (var descriptor in DischargeDescriptor.values) {
    if (input.startsWith(descriptor.code)) {
      descriptors.add(descriptor);
      return _consumeDescriptor(consumePrefix(descriptor.code, input), descriptors);
    }
  }
  return input;
}

DischargeType _getDischargeType(String input) {
  for (var dischargeType in DischargeType.values) {
    if (input.startsWith(dischargeType.code)) {
      return dischargeType;
    }
  }
  throw Exception("$input does not have a discharge type");
}

Flow? _getFlow(String input) {
  for (var flow in Flow.values) {
    if (input.startsWith(flow.code)) {
      return flow;
    }
  }
  return null;
}

String consumePrefix(String prefix, String input) {
  return input.replaceFirst(prefix, "");
}