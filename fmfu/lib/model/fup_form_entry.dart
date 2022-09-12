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
  final String subSection;
  final String? subSubSection;
  final int questionIndex;

  const FollowUpFormEntryId({
    required this.section,
    required this.subSection,
    this.subSubSection = "",
    required this.questionIndex,
  });
}