import 'package:flutter/material.dart';
import 'package:fmfu/logic/comment_manager.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_entry.dart';
import 'package:loggy/loggy.dart';

class FollowUpFormViewModel extends ChangeNotifier with GlobalLoggy {
  Map<FollowUpFormEntryId, String> entries = {};
  Map<BoxId, List<FollowUpFormComment>> comments = {};
  CommentLayout commentLayout = CommentLayout({});

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

  List<CommentRowData> getCommentsForPage(int pageNum) {
    return commentLayout.getCommentsForPage(pageNum);
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
    refreshCommentLayout();
  }

  void updateCommentProblem(CommentId id, String problem) {
    var comment = comments[id.boxId]![id.index];
    comments[id.boxId]![id.index] = comment.updateProblem(problem);
    loggy.info("Updating comment for $id from ${comment.problem} to $problem");
    refreshCommentLayout();
  }

  void updateCommentPlan(CommentId id, String plan) {
    var comment = comments[id.boxId]![id.index];
    comments[id.boxId]![id.index] = comment.updatePlanOfAction(plan);
    loggy.info("Updating plan for $id from ${comment.planOfAction} to $plan");
    refreshCommentLayout();
  }

  void removeComment(CommentId id) {
    comments[id.boxId]!.removeAt(id.index);
    loggy.info("Removing comment: $id");
    refreshCommentLayout();
  }

  void refreshCommentLayout() {
    commentLayout = CommentLayout.forComments(comments.values.expand((i) => i).toList());
    notifyListeners();
  }
}
