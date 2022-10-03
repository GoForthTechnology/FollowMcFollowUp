import 'package:fmfu/logic/comment_manager.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:test/test.dart';

void main() {
  test("foo", () {
    var comments = [
      FollowUpFormComment(
        id: CommentId(
          index: 0,
          boxId: BoxId(
            followUp: 0,
            itemId: ItemId(
              section: 8,
              subSection: "A",
            ),
          ),
        ),
        date: DateTime.now(),
        problem: "foo",
        planOfAction: "foo",
      ),
    ];
    CommentLayout.forComments(comments);
  });
}