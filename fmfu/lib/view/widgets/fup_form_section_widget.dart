import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_entry.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/box_grid_widget.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

import 'fup_form_comment_widget.dart';

class FollowUpFormSectionWidget extends StatelessWidget with UiLoggy {
  final List<FollowUpFormItem> items;
  final int indexOffset;
  final int nItems;
  final bool boxSection;
  final String? explanationSectionTitle;

  const FollowUpFormSectionWidget({
    Key? key,
    required this.items,
    required this.indexOffset,
    required this.nItems,
    this.boxSection = false,
    this.explanationSectionTitle,
  }) : super(key: key);

   static FollowUpFormSectionWidget createSingle(
       List<List<FollowUpFormItem>> itemGroups, {
         required int groupIndex, bool boxSection = false, String? explanationSectionTitle,
       }) {
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
      explanationSectionTitle: explanationSectionTitle,
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
    List<GridRow> explanationRows = [];
    bool includeExplanationSection = explanationSectionTitle != null;
    for (int i=indexOffset; i < indexOffset + nItems; i++) {
      var item = items[i];
      String code = item.subSection;
      if (item.subSubSection != null) {
        code = item.subSubSection!;
      }
      titles.add(_title(code, item.description(), style: item.style()));
      rows.add(GridRow(item, i, _showInputDialog));
      if (includeExplanationSection) {
        explanationRows.add(GridRow(item, i, _showInputDialog, numColumns: 1));
      }
    }

    Widget titleWidget = Padding(padding: const EdgeInsets.only(top: 5), child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: titles,
    ));
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
    if (includeExplanationSection && indexOffset == 0) {
      titleWidget = Padding(
        padding: const EdgeInsets.only(top: 30),
        child: titleWidget,
      );
    }

    return IntrinsicHeight(child: Row(
      children: [
        if (includeExplanationSection) Padding(
          padding: const EdgeInsets.only(right: 10),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(explanationSectionTitle!, textAlign: TextAlign.center,),
          ),
        ),
        if (includeExplanationSection) Padding(
          padding: const EdgeInsets.only(right: 10),
          child: BoxGridWidget(
            rows: explanationRows,
            headerRow: indexOffset == 0 ? BoxGridWidget.explanationHeaderRow() : null,
            includeRowLabels: false,
            nColumns: 1,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: titleWidget,
        ),
        const Spacer(),
        BoxGridWidget(
          rows: rows,
          headerRow: indexOffset == 0 ? BoxGridWidget.basicHeaderRow(8) : null,
        ),
      ],
    ));
  }

  void _showInputDialog(BuildContext context, int itemIndex, int followUpIndex) {
    if (itemIndex < 0 || itemIndex >= items.length) {
      return;
    }
    FollowUpFormItem item = items[itemIndex];
    var saveItems = [];
    showDialog(context: context, builder: (BuildContext context) {
      return Consumer<FollowUpFormViewModel>(builder: (context, model, child) => StatefulBuilder(builder: (context, setState) {
        var commentWidgets = model.getComments(BoxId(
          followUp: followUpIndex,
          itemId: item.id(),
        )).mapIndexed((i, comment) => CommentWidget(
          item: item,
          followUpIndex: followUpIndex,
          commentIndex: i,
        )).toList();
        saveItems.addAll(commentWidgets);
        return AlertDialog(
            title: Text(
                "Follow Up #${followUpIndex + 1} -- ${item.section}${item.subSection}"),
            // IntrinsicHeight to shrink the dialog around the column
            // BoxConstraint to keep it from growing unbounded horizontally
            content: IntrinsicHeight(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 350, maxWidth: 500, maxHeight: 500), child: Column(children: [
              ..._getItemRows(context, model, item, followUpIndex),
              // TODO: fix issue when too many comments are added
              Expanded(child: Column(children: commentWidgets)),
              Padding(padding: const EdgeInsets.only(bottom: 20), child: ElevatedButton(
                onPressed: () => setState(() {
                  var item = items[itemIndex];
                  model.addComment(BoxId(
                    followUp: followUpIndex,
                    itemId: item.id(),
                  ));
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
      }));
    }).then((val) {
      loggy.debug("Saving dialog state for $item on followUpIndex: $followUpIndex");
      for (var item in saveItems) {
        item.save();
      }
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

  List<Widget> _getQuestionRows(BuildContext context, FollowUpFormViewModel model, Question question, FollowUpFormEntryId id) {
     String? selectedItem = model.getEntry(id);
    return [
      Text(question.description),
      Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: question.acceptableInputs.map((item) => Padding(
          padding: const EdgeInsets.all(2),
          child: ElevatedButton(
            onPressed: () => model.updateEntry(id, item == selectedItem ? null : item),
            style: item == selectedItem ? ElevatedButton.styleFrom(primary: Colors.pinkAccent) : ElevatedButton.styleFrom(primary: Colors.blueAccent),
            child: Text(item),
          ),
        )).toList(),
      )),
    ];
  }

  List<Widget> _getItemRows(BuildContext context, FollowUpFormViewModel model, FollowUpFormItem item, int followUpIndex) {
    return item.questions
        .mapIndexed((i, q) => _getQuestionRows(context, model, q, item.entryId(i, followUpIndex)))
        .expand((e) => e)
        .toList();
  }


  Widget _title(String code, String text, {TextStyle? style}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (code != "") Text("$code. ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Expanded(child: Text(text, style: style, maxLines: 2, softWrap: true)),
    ]);
  }
}