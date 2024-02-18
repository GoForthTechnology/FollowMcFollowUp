import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:loggy/loggy.dart';

enum Question {
  sticker,
  text
}

class ExerciseViewModel extends ChangeNotifier with GlobalLoggy {
  final Map<int, StickerWithText> stampAnswerSubmissions = {};
  Sticker? currentStickerSelection;
  String? currentStickerTextSelection;

  int questionIndex = -1;

  Question getQuestion() {
    return questionIndex % 2 == 0 ? Question.text : Question.sticker;
  }

  int _entryIndex() {
    if (questionIndex < 0) {
      return 0;
    }
    return questionIndex ~/ 2 + questionIndex % 2;
  }

  bool canSubmit() {
    switch (getQuestion()) {
      case Question.sticker:
        return currentStickerSelection != null;
      case Question.text:
        return currentStickerTextSelection != null;
    }
  }

  void submit() {
    print("Submitting questionIndex $questionIndex");
    if (!canSubmit()) {
      throw StateError("!canSubmit()");
    }
    int index = _entryIndex();
    print("${getQuestion()} $index");
    switch (getQuestion()) {
      case Question.sticker:
        stampAnswerSubmissions[index] = StickerWithText(currentStickerSelection!, "");
        currentStickerSelection = null;
        break;
      case Question.text:
        var existing = stampAnswerSubmissions[index]!;
        stampAnswerSubmissions[index] = existing.withText(currentStickerTextSelection);
        currentStickerTextSelection = null;
        break;
    }
    questionIndex++;
    notifyListeners();
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

  bool hasAnswer(int entryIndex) {
    return stampAnswerSubmissions.containsKey(entryIndex);
  }

  bool hasCorrectStamp(int entryIndex, ChartEntry entry) {
    var stickerWithText = stampAnswerSubmissions[entryIndex]!;
    print("Checking entry with ${entry.renderedObservation?.getSticker()} and ${entry.renderedObservation?.getStickerText()} against $stickerWithText");
    return entry.withManualSticker(stickerWithText).isCorrectSticker();
  }
}

class Student {
  final int id;
  final String firstName;
  final String lastName;

  Student(this.id, this.firstName, this.lastName);
}
