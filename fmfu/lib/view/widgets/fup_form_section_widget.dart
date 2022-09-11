import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/box_grid_widget.dart';

class FollowUpFormSectionWidget extends StatelessWidget {
  final List<FollowUpFormItem> items;
  final int indexOffset;
  final int nItems;
  final bool boxSection;

  const FollowUpFormSectionWidget({required this.items, required this.indexOffset, required this.nItems, Key? key, this.boxSection = false}) : super(key: key);

   static FollowUpFormSectionWidget createSingle(List<List<FollowUpFormItem>> itemGroups, {required int groupIndex, bool boxSection = false}) {
    List<FollowUpFormItem> items = itemGroups.expand((i) => i).toList();
    int indexOffset = 0;
    for (int i=0; i<groupIndex; i++) {
      indexOffset += itemGroups[i].length;
    }
    return FollowUpFormSectionWidget(
      items: items,
      indexOffset: indexOffset,
      nItems: itemGroups[groupIndex].length,
      boxSection: boxSection,
    );
  }

  static List<FollowUpFormSectionWidget> create(List<List<FollowUpFormItem>> itemGroups) {
    List<FollowUpFormItem> items = itemGroups.expand((i) => i).toList();
    List<FollowUpFormSectionWidget> widgets = [];
    int indexOffset = 0;
    for (var group in itemGroups) {
      widgets.add(FollowUpFormSectionWidget(
        items: items,
        indexOffset: indexOffset,
        nItems: group.length,
      ));
      indexOffset += group.length;
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titles = [];
    List<GridRow> rows = [];
    for (int i=indexOffset; i < indexOffset + nItems; i++) {
      var item = items[i];
      String code = item.subSection;
      if (item.subSubSection != null) {
        code = item.subSubSection!;
      }
      titles.add(_title(code, item.description(), style: item.style()));
      rows.add(GridRow(item, i, _showInputDialog));
    }

    Widget titleWidget = Padding(padding: const EdgeInsets.only(top: 5), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: titles));
    if (boxSection) {
      titleWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          color: Colors.grey[300],
        ),
        child: Padding(padding: const EdgeInsets.all(4), child: titleWidget),
      );
    }

    return IntrinsicHeight(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      titleWidget,
      const Spacer(),
      BoxGridWidget(
        rows: rows,
        includeColumnHeadings: indexOffset == 0,
      )
    ]));
  }

  void _showInputDialog(BuildContext context, int itemIndex, int followUpIndex) {
    if (itemIndex < 0 || itemIndex >= items.length) {
      return;
    }
    FollowUpFormItem item = items[itemIndex];
    showDialog(context: context, builder: (BuildContext context) {
      String? selectedItem;
      List<String> comments = [];
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
            title: Text(
                "${item.section}${item.subSection} - ${followUpIndex + 1}"),
            // IntrinsicHeight to shrink the dialog around the column
            // BoxConstraint to keep it from growing unbounded horizontally
            content: IntrinsicHeight(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 350, maxWidth: 500), child: Column(children: [
              ..._getItemRows(context, item, selectedItem, (item) {
                setState(() {
                  selectedItem = item;
                });
              }),
              // TODO: fix issue when too many comments are added
              ...comments.map((comment) => CommentWidget(onRemoveComment: () => setState(() {
                comments.removeLast();
              }),
              )).toList(),
              Padding(padding: const EdgeInsets.only(bottom: 20), child: ElevatedButton(
                onPressed: () => setState(() {
                  comments.add("");
                }),
                child: const Text("Add Comment"),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getPreviousButton(context, itemIndex, followUpIndex),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
                  getNextButton(context, itemIndex, followUpIndex),
                ],
              )
            ])),
            ));
      });
    });
  }

  Widget getPreviousButton(BuildContext context, int itemIndex, int followUpIndex) {
    if (itemIndex <= 0) {
      return Container();
    }
    return TextButton(onPressed: () {
      Navigator.pop(context);
      _showInputDialog(context, itemIndex - 1, followUpIndex);
    }, child: const Text("Previous"));
  }

  Widget getNextButton(BuildContext context, int itemIndex, int followUpIndex) {
    if (itemIndex >= items.length - 1) {
      return Container();
    }
    return TextButton(onPressed: () {
      Navigator.pop(context);
      _showInputDialog(context, itemIndex + 1, followUpIndex);
    }, child: const Text("Next"));
  }

  List<Widget> _getQuestionRows(BuildContext context, Question question, String? selectedItem, Function(String?) onPressed) {
    return [
      Text(question.description),
      Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: question.acceptableInputs.map((item) => Padding(
          padding: const EdgeInsets.all(2),
          child: ElevatedButton(
            onPressed: () => onPressed(item == selectedItem ? null : item),
            style: item == selectedItem ? ElevatedButton.styleFrom(primary: Colors.pinkAccent) : ElevatedButton.styleFrom(primary: Colors.blueAccent),
            child: Text(item),
          ),
        )).toList(),
      )),
    ];
  }

  List<Widget> _getItemRows(BuildContext context, FollowUpFormItem item, String? selectedItem, Function(String?) onPressed) {
    return item.questions.map((q) => _getQuestionRows(context, q, selectedItem, onPressed)).expand((e) => e).toList();
  }


  Widget _title(String code, String text, {TextStyle? style}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (code != "") Text("$code. ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(text, style: style),
    ]);
  }
}