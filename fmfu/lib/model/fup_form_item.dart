
import 'package:flutter/material.dart';

class FollowUpFormItem {

  final int section;
  final String subSection;
  final List<Question> questions;

  final bool splitBoxes;
  final Set<int> disabledCells;

  FollowUpFormItem({
    required this.section,
    required this.subSection,
    required this.questions,
    this.disabledCells = const {},
  }) : splitBoxes = questions.length > 1;

  String description() {
    return questions.map((q) => q.description).join("\n");
  }

  TextStyle? style() {
    for (var question in questions) {
      if (question.style != null) {
        return question.style;
      }
    }
    return null;
  }
}

class Question {
  static const List<String> defaultAcceptableInputs = ["1", "2", "X", "--"];

  final String description;
  final TextStyle? style;
  final List<String> acceptableInputs;

  Question({required this.description, this.style, this.acceptableInputs = defaultAcceptableInputs});

}