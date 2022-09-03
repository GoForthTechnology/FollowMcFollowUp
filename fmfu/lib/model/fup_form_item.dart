
import 'package:flutter/material.dart';

class FollowUpFormItem {
  static const List<String> defaultAcceptableInputs = ["1", "2", "X", "--"];

  final int section;
  final String subSection;
  final String description;
  final TextStyle? descriptionStyle;

  final List<String> acceptableInputs;

  final bool splitBoxes;
  final Set<int> disabledCells;

  FollowUpFormItem({
    required this.section,
    required this.subSection,
    required this.description,
    this.splitBoxes = false,
    this.descriptionStyle,
    this.disabledCells = const {},
    this.acceptableInputs = defaultAcceptableInputs,
  });
}