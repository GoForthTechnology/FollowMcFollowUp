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
              section: 4,
              subSection: "N",
            ),
          ),
        ),
        date: DateTime.now(),
        problem: "foo",
        planOfAction: "foo",
      ),
    ];
    var layout = CommentLayout.forComments(comments);
    expect(layout.getCommentsForPage(3).length, 0);
    expect(layout.getCommentsForPage(4).length, 1);
    expect(layout.getCommentsForPage(5).length, 0);
  });
}