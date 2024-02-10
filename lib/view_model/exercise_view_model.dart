import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';

class ExerciseViewModel extends ChangeNotifier with GlobalLoggy {
  final List<Student> _students = [];
  final Map<int, StickerWithText> stampAnswerSubmissions = {};
  final Map<int, Observation> vdrsAnswerSubmissions = {};
  Sticker? currentStickerSelection;
  String? currentStickerTextSelection;

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

  List<Student> students() {
    return _students;
  }

  void updateStickerSelection(Sticker? sticker) {
    loggy.debug("Updating sticker selection: $sticker");
    if (currentStickerSelection == sticker) {
      currentStickerSelection = null;
    } else {
      currentStickerSelection = sticker;
    }
    notifyListeners();
  }

  void updateStickerTextSelection(String? text) {
    loggy.debug("Updating sticker text: $text");
    if (currentStickerTextSelection == text) {
      currentStickerTextSelection = null;
    } else {
      currentStickerTextSelection = text;
    }
    notifyListeners();
  }

  StickerWithText? getCurrentStickerWithText() {
    if (currentStickerSelection == null) {
      return null;
    }
    return StickerWithText(currentStickerSelection!, currentStickerTextSelection);
  }

  void loadPreviousSelection(int entryIndex) {
    final previousIndex = entryIndex - 1;
    if (!hasAnswer(previousIndex)) {
      return;
    }
    _updateState(previousIndex);
  }

  void loadNextSelection(int entryIndex) {
    final nextIndex = entryIndex + 1;
    if (!hasAnswer(nextIndex)) {
      clearSelection();
      return;
    }
    _updateState(nextIndex);
  }

  void _updateState(int index) {
    var previousAnswer = stampAnswerSubmissions[index];
    currentStickerTextSelection = previousAnswer?.text;
    currentStickerSelection = previousAnswer?.sticker;
    var previousVDRS = vdrsAnswerSubmissions[index];
    currentFlow = previousVDRS?.flow;
    currentDischargeType = previousVDRS?.dischargeSummary?.dischargeType;
    currentDischargeFrequency = previousVDRS?.dischargeSummary?.dischargeFrequency;
    currentDischargeDescriptors = previousVDRS?.dischargeSummary?.dischargeDescriptors.toSet() ?? {};
    notifyListeners();
  }

  void clearSelection() {
    currentStickerSelection = null;
    currentStickerTextSelection = null;
    currentDischargeDescriptors.clear();
    currentDischargeType = null;
    currentDischargeFrequency = null;
    currentFlow = null;

    notifyListeners();
  }

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  bool hasAnswer(int entryIndex) {
    return stampAnswerSubmissions.containsKey(entryIndex);
  }

  bool canSaveAnswer() {
    bool hasStamp = currentStickerSelection != null;
    bool hasVDRS = currentFlow != null || (
        currentDischargeType != null && currentDischargeFrequency != null);
    return hasStamp && hasVDRS;
  }

  void submitAnswer(int entryIndex) {
    if (!canSaveAnswer()) {
      return;
    }
    stampAnswerSubmissions[entryIndex] = StickerWithText(currentStickerSelection!, currentStickerTextSelection);
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
    stampAnswerSubmissions.remove(entryIndex);
    vdrsAnswerSubmissions.remove(entryIndex);
    currentStickerSelection = null;
    currentStickerTextSelection = null;
    notifyListeners();
  }
}

class Student {
  final int id;
  final String firstName;
  final String lastName;

  Student(this.id, this.firstName, this.lastName);
}
