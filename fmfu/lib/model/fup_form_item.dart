
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_entry.dart';

class FollowUpFormItem {

  final int section;
  final String? superSection;
  final String subSection;
  final String? subSubSection;
  final List<Question> questions;

  final Set<int> disabledCells;

  const FollowUpFormItem({
    required this.section,
    required this.subSection,
    required this.questions,
    this.superSection,
    this.subSubSection,
    this.disabledCells = const {},
  });

  FollowUpFormEntryId entryId(int questionIndex, int followUpNum) {
    return FollowUpFormEntryId(
      section: section,
      superSection: superSection,
      subSection: subSection,
      subSubSection: subSubSection,
      questionIndex: questionIndex,
      followUpIndex: followUpNum,
    );
  }

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

  const Question({required this.description, this.style, this.acceptableInputs = defaultAcceptableInputs});
}