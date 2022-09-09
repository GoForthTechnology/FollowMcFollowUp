class FollowUpFormComment {
  final DateTime date;
  final int followUpNum;
  final int sectionNum;
  final String problem;
  final String planOfAction;

  FollowUpFormComment({
    required this.date,
    required this.followUpNum,
    required this.sectionNum,
    required this.problem,
    required this.planOfAction});
}