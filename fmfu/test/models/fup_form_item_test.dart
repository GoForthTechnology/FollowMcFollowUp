
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/fup_form_widget.dart';
import 'package:test/test.dart';

void main() {
  test("ItemId compareTo", () {
    List<List<List<FollowUpFormItem>>> allTheItems = [
      page3Items,
      page4Items,
      page5Items,
      page6Items,
      page7Items,
      page9Items,
      page10Items,
      page11Items,
      page22Items,
      page23Items,
    ];
    List<FollowUpFormItem> flatItems = allTheItems.expand((listOfList) => listOfList.expand((list) => list)).toList();
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