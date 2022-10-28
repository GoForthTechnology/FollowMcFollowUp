
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/model/fup_form_layout.dart';
import 'package:test/test.dart';

void main() {
  test("ItemId compareTo", () {
    List<FollowUpFormItem> flatItems = FollowUpFormLayout.items();
    int previousI = -1;
    for (int i=0; i<flatItems.length; i++) {
      if (previousI >= 0) {
        var a = flatItems[i].id();
        var b = flatItems[previousI].id();
        var compareResult = a.compareTo(b);
        expect(compareResult > 0, true, reason: "Expected $a to be greater than $b");
      }
      previousI = i;
    }
  });
}