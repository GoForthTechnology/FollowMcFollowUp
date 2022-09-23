import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';

class ExerciseViewModel extends ChangeNotifier with GlobalLoggy {
  final List<Student> _students = [];
  final Map<int, StickerWithText> answerSubmissions = {};
  Sticker? currentStickerSelection;
  String? currentStickerTextSelection;

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
    if (!hasAnswer(entryIndex - 1)) {
      return;
    }
    var previousAnswer = answerSubmissions[entryIndex - 1];
    currentStickerTextSelection = previousAnswer?.text;
    currentStickerSelection = previousAnswer?.sticker;
    notifyListeners();
  }

  void clearSelection() {
    currentStickerSelection = null;
    currentStickerTextSelection = null;
    notifyListeners();
  }

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  bool hasAnswer(int entryIndex) {
    return answerSubmissions.containsKey(entryIndex);
  }

  bool canSaveAnswer() {
    return currentStickerSelection != null;
  }

  void submitAnswer(int entryIndex) {
    if (!canSaveAnswer()) {
      return;
    }
    answerSubmissions[entryIndex] = StickerWithText(currentStickerSelection!, currentStickerTextSelection);
    notifyListeners();
  }

  void clearAnswer(int entryIndex) {
    answerSubmissions.remove(entryIndex);
    notifyListeners();
  }
}

class Student {
  final int id;
  final String firstName;
  final String lastName;

  Student(this.id, this.firstName, this.lastName);
}
