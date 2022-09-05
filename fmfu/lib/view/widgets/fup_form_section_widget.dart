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
    for (var item in items) {
      titles.add(_title(item.subSection, item.description(), style: item.style()));
      rows.add(GridRow(item));
    }
    return IntrinsicHeight(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(padding: const EdgeInsets.only(top: 5), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: titles)),
      Spacer(),
      BoxGridWidget(
        rows: rows,
      )
    ]));
  }

  Widget _title(String code, String text, {TextStyle? style}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("$code. ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(text, style: style),
    ]);
  }
}