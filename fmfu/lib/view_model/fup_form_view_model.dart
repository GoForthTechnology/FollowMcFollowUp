import 'package:flutter/material.dart';
import 'package:fmfu/logic/comment_manager.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_entry.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:loggy/loggy.dart';

class FollowUpFormViewModel extends ChangeNotifier with GlobalLoggy {
  Map<FollowUpFormEntryId, String> entries = {};
  Map<BoxId, List<FollowUpFormComment>> comments = {};

  String? getEntry(FollowUpFormEntryId id) {
    if (!entries.containsKey(id)) {
      return null;
    }
    return entries[id];
  }

  void updateEntry(FollowUpFormEntryId id, String? value) {
    loggy.debug("Updating $id with $value");
    if (value == null) {
      entries.remove(id);
    } else {
      entries[id] = value;
    }
    notifyListeners();
  }

  List<FollowUpFormComment> getComments(BoxId id) {
    return comments[id] ?? [];
  }

  List<CommentRowData> getCommentsForSection(ItemId previousItemId, ItemId? nextItemId) {
    List<FollowUpFormComment> out = [];
    for (var boxId in comments.keys) {
      if (boxId.itemId.section == previousItemId.section) {
        out.addAll(comments[boxId] ?? []);
      }
    }
    return out
        .map((comment) => CommentRowData.fromComment(comment))
        .expand((element) => element)
        .toList();
  }

  FollowUpFormComment? getComment(CommentId commentId) {
    return getComments(commentId.boxId)[commentId.index];
  }

  void addComment(BoxId id) {
    var currentComments = comments[id] ?? [];
    int index = currentComments.length;
    comments[id] = currentComments + [FollowUpFormComment(
      id: CommentId(boxId: id, index: index),
      date: DateTime.now(),
      problem: "",
      planOfAction: "",
    )];
    loggy.info("Added comment for box: $id");
    notifyListeners();
  }

  void updateCommentProblem(CommentId id, String problem) {
    var comment = comments[id.boxId]![id.index];
    comments[id.boxId]![id.index] = comment.updateProblem(problem);
    loggy.info("Updating comment for $id from ${comment.problem} to $problem");
    notifyListeners();
  }

  void updateCommentPlan(CommentId id, String plan) {
    var comment = comments[id.boxId]![id.index];
    comments[id.boxId]![id.index] = comment.updatePlanOfAction(plan);
    loggy.info("Updating plan for $id from ${comment.planOfAction} to $plan");
    notifyListeners();
  }

  void removeComment(CommentId id) {
    comments[id.boxId]!.removeAt(id.index);
    loggy.info("Removing comment: $id");
    notifyListeners();
  }
}
