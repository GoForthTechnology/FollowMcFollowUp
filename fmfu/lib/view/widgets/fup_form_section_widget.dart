import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/box_grid_widget.dart';

class FollowUpFormSectionWidget extends StatelessWidget {
  List<FollowUpFormItem> items;

  FollowUpFormSectionWidget({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> titles = [];
    List<GridRow> rows = [];
    for (int i=0; i < items.length; i++) {
      var item = items[i];
      titles.add(_title(item.subSection, item.description(), style: item.style()));
      rows.add(GridRow(item, i, _showInputDialog));
    }

    return IntrinsicHeight(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(padding: const EdgeInsets.only(top: 5), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: titles)),
      const Spacer(),
      BoxGridWidget(
        rows: rows,
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
                "Section: ${item.section}${item.subSection} - ${followUpIndex + 1}"),
            // IntrinsicHeight to shrink the dialog around the column
            // BoxConstraint to keep it from growing unbounded horizontally
            content: IntrinsicHeight(child:ConstrainedBox(constraints: const BoxConstraints(minWidth: 250, maxWidth: 500), child: Column(children: [
              ..._getItemRows(item, (item) {
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

  List<Widget> _getQuestionRows(Question question, Function(String?) onPressed) {
    return [
      Text(question.description),
      Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: question.acceptableInputs.map((item) => Padding(
          padding: const EdgeInsets.all(2),
          child: ElevatedButton(
            onPressed: () => onPressed(item),
            child: Text(item),
          ),
        )).toList(),
      )),
    ];
  }

  List<Widget> _getItemRows(FollowUpFormItem item, Function(String?) onPressed) {
    return item.questions.map((q) => _getQuestionRows(q, onPressed)).expand((e) => e).toList();
  }


  Widget _title(String code, String text, {TextStyle? style}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("$code. ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(text, style: style),
    ]);
  }
}