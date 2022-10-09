import 'package:fmfu/model/fup_form_item.dart';

class FollowUpFormComment extends Comparable<FollowUpFormComment> {
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

  ItemId get itemId {
    return id.boxId.itemId;
  }

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

  @override
  int compareTo(FollowUpFormComment other) {
    return id.compareTo(other.id);
  }
}

class CommentId extends Comparable<CommentId> {
  final BoxId boxId;
  final int index;

  CommentId({
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

  @override
  int compareTo(CommentId other) {
    var boxIdResult = boxId.compareTo(other.boxId);
    if (boxIdResult != 0) {
      return boxIdResult;
    }
    return index.compareTo(other.index);
  }
}

class BoxId extends Comparable<BoxId> {
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
  }

  @override
  int get hashCode => Object.hash(followUp, itemId);

  @override
  int compareTo(BoxId other) {
    var followUpUpResult = followUp.compareTo(other.followUp);
    if (followUpUpResult != 0) {
      return followUpUpResult;
    }
    return itemId.compareTo(other.itemId);
  }
}