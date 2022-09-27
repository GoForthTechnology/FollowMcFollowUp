import 'package:fmfu/model/fup_form_item.dart';

class FollowUpFormComment {
  final CommentId id;
  final DateTime date;
  final String problem;
  final String planOfAction;

  FollowUpFormComment({
    required this.id,
    required this.date,
    required this.problem,
    required this.planOfAction,
  });

  FollowUpFormComment updateProblem(String problem) {
    return FollowUpFormComment(
      id: id,
      date:date,
      problem: problem,
      planOfAction: planOfAction,
    );
  }

  FollowUpFormComment updatePlanOfAction(String planOfAction) {
    return FollowUpFormComment(
      id: id,
      date:date,
      problem: problem,
      planOfAction: planOfAction,
    );
  }
}

class CommentId {
  final BoxId boxId;
  final int index;

  const CommentId({
    required this.boxId,
    required this.index,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CommentId
        && other.index == index
        && other.boxId == boxId
        ;
  }

  @override
  int get hashCode => Object.hash(index, boxId);

  @override
  String toString() {
    return "{boxId: $boxId, index: $index}";
  }
}

class BoxId {
  final int followUp;
  final ItemId itemId;

  BoxId({
    required this.followUp,
    required this.itemId,
  });

  @override
  String toString() {
    return "{followUp: $followUp, itemId: $itemId}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BoxId
        && other.followUp == followUp
        && other.itemId == itemId;
    ;
  }

  @override
  int get hashCode => Object.hash(followUp, itemId);
}