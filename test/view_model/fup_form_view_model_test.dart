import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_entry.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:test/test.dart';

void main() {
  group("Entries", () {
    test("Successful CRUD", () {
      FollowUpFormViewModel viewModel = FollowUpFormViewModel();
      var id = const FollowUpFormEntryId(
        section: 4,
        subSection: "A",
        questionIndex: 0,
        followUpIndex: 0,
      );
      expect(viewModel.getEntry(id), null);

      var expectedValue = "some value";
      viewModel.updateEntry(id, expectedValue);
      expect(viewModel.getEntry(id), expectedValue);

      viewModel.updateEntry(id, null);
      expect(viewModel.entries.isEmpty, true);
    });
  });

  group("Comments", () {
    test("Successful CRUD", () {
      FollowUpFormViewModel viewModel = FollowUpFormViewModel();
      var boxId = BoxId(followUp: 1, itemId: ItemId(section: 4, subSection: "A"));
      var commentId = CommentId(boxId: boxId, index: 0);
      expect(viewModel.hasComment(commentId), false);

      viewModel.addComment(boxId);
      expect(viewModel.hasComment(commentId), true);
      expect(viewModel.getComments(boxId).length, 1);

      var expectedPlan = "a great plan";
      viewModel.updateCommentPlan(commentId, expectedPlan);
      var expectedProblem = "a serious problem";
      viewModel.updateCommentProblem(commentId, expectedProblem);

      var comment = viewModel.getComment(CommentId(boxId: boxId, index: 0))!;
      expect(comment.planOfAction, expectedPlan);
      expect(comment.problem, expectedProblem);

      viewModel.removeComment(commentId);
      expect(viewModel.getComments(boxId).length, 0);
    });
    test("Unsuccessful CRUD", () {
      FollowUpFormViewModel viewModel = FollowUpFormViewModel();
      var boxId = BoxId(followUp: 1, itemId: ItemId(section: 4, subSection: "A"));
      var commentId = CommentId(boxId: boxId, index: 0);

      expect(() => viewModel.removeComment(commentId), throwsArgumentError);
      expect(() => viewModel.updateCommentProblem(commentId, "problem"), throwsArgumentError);
      expect(() => viewModel.updateCommentPlan(commentId, "plan"), throwsArgumentError);
    });
  });
}