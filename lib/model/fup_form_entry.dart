class FollowUpFormEntry {
  final FollowUpFormEntryId id;
  final String value;

  const FollowUpFormEntry({
    required this.id,
    required this.value,
  });
}

class FollowUpFormEntryId {
  final int section;
  final String? superSection;
  final String subSection;
  final String? subSubSection;
  final int questionIndex;
  final int followUpIndex;

  const FollowUpFormEntryId({
    required this.section,
    required this.subSection,
    this.superSection,
    this.subSubSection = "",
    required this.questionIndex,
    required this.followUpIndex,
  });

  @override
  String toString() {
    return "{section: $section, subSection: $subSection, subSubSection: $subSubSection, question: $questionIndex, followUpNum: $followUpIndex}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FollowUpFormEntryId
        && other.section == section
        && other.superSection == superSection
        && other.subSection == subSection
        && other.subSubSection == subSubSection
        && other.questionIndex == questionIndex
        && other.followUpIndex == followUpIndex
    ;
  }

  @override
  int get hashCode => Object.hash(section, superSection, subSection, subSubSection, questionIndex, followUpIndex);
}