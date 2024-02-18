
import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/model/observation.dart';

class VdrsViewModel extends ChangeNotifier {
  final Map<int, Observation> vdrsAnswerSubmissions = {};

  Flow? currentFlow;
  DischargeType? currentDischargeType;
  DischargeFrequency? currentDischargeFrequency;
  Set<DischargeDescriptor> currentDischargeDescriptors = {};

  void addDischargeDescriptor(DischargeDescriptor descriptor) {
    currentDischargeDescriptors.add(descriptor);
    notifyListeners();
  }

  void removeDischargeDescriptor(DischargeDescriptor descriptor) {
    currentDischargeDescriptors.remove(descriptor);
    notifyListeners();
  }

  void updateCurrentFlow(Flow? flow) {
    currentFlow = flow;
    notifyListeners();
  }

  void updateCurrentDischargeType(DischargeType? dischargeType) {
    currentDischargeType = dischargeType;
    notifyListeners();
  }

  void updateCurrentDischargeFrequency(DischargeFrequency? dischargeFrequency) {
    currentDischargeFrequency = dischargeFrequency;
    notifyListeners();
  }

  void clearSelection() {
    currentDischargeDescriptors.clear();
    currentDischargeType = null;
    currentDischargeFrequency = null;
    currentFlow = null;

    notifyListeners();
  }

  void submitAnswer(int entryIndex) {
    DischargeSummary? dischargeSummary;
    if (currentDischargeType != null) {
      dischargeSummary = DischargeSummary(
        dischargeType: currentDischargeType!,
        dischargeDescriptors: currentDischargeDescriptors.toList(),
        dischargeFrequency: currentDischargeFrequency!,
      );
    }
    vdrsAnswerSubmissions[entryIndex] = Observation(
      flow: currentFlow,
      dischargeSummary: dischargeSummary,
    );
    notifyListeners();
  }

  void clearAnswer(int entryIndex) {
    vdrsAnswerSubmissions.remove(entryIndex);
    notifyListeners();
  }
}