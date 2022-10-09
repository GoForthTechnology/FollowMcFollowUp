import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:test/test.dart';

void main() {
  test("Dummy Test", () {
    FollowUpFormViewModel viewModel = FollowUpFormViewModel();
    var id = BoxId(followUp: 1, itemId: ItemId(section: 4, subSection: "A"));
    viewModel.addComment(id);
    expect(viewModel.getComments(id).length, 1);
  });
}