
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_entry.dart';

class ItemId extends Comparable<ItemId> {
  final int section;
  final String? superSection;
  final String subSection;
  final String? subSubSection;

  final String? previousSubSection;
  final String? nextSubSection;

  ItemId(this.section, this.superSection, this.subSection, this.subSubSection, this.previousSubSection, this.nextSubSection);

  static ItemId forItem(FollowUpFormItem item) {
    return ItemId(item.section, item.superSection, item.subSection, item.subSubSection, item.previousSubSection, item.nextSubSection);
  }

  @override
  String toString() {
    return "{section: $section, superSection: $superSection, subSection: $subSection, subSubSection: $subSubSection}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ItemId
        && other.section == section
        && other.superSection == superSection
        && other.subSection == subSection
        && other.subSubSection == subSubSection
    ;
  }

  @override
  int get hashCode => Object.hash(section, superSection, subSection, subSubSection);

  @override
  int compareTo(ItemId other) {
    if (section < other.section) {
      return -1;
    }
    if (section > other.section) {
      return 1;
    }
    var superSectionResult = (superSection ?? "").compareTo(other.superSection ?? "");
    if (superSectionResult != 0) {
      return superSectionResult;
    }

    var subSectionResult = subSection.compareTo(other.subSection);
    if (subSection == "") {
      if (nextSubSection != null) {
        if (nextSubSection == other.subSection) {
          return -1;
        } else {
          subSectionResult = nextSubSection!.compareTo(other.subSection);
        }
      }
      if (previousSubSection != null) {
        if (previousSubSection == other.subSection) {
          return 1;
        } else {
          subSectionResult = previousSubSection!.compareTo(other.subSection);
        }
      }
    }
    if (subSectionResult != 0) {
      return subSectionResult;
    }
    var subSubSectionResult = (subSubSection ?? "").compareTo(other.subSubSection ?? "");
    var thisSubSubSectionNumber = int.tryParse(subSubSection ?? "");
    var otherSubSubSectionNumber = int.tryParse(other.subSubSection ?? "");
    if (thisSubSubSectionNumber != null && otherSubSubSectionNumber != null) {
      subSubSectionResult = thisSubSubSectionNumber.compareTo(otherSubSubSectionNumber);
    }
    return subSubSectionResult;
  }
}

class FollowUpFormItem {

  final int section;
  final String? superSection;
  final String subSection;
  final String? subSubSection;
  final List<Question> questions;

  final String? previousSubSection;
  final String? nextSubSection;

  final Set<int> disabledCells;

  const FollowUpFormItem({
    required this.section,
    required this.subSection,
    required this.questions,
    this.superSection,
    this.subSubSection,
    this.disabledCells = const {},
    this.previousSubSection,
    this.nextSubSection,
  });

  ItemId id() {
    return ItemId.forItem(this);
  }

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