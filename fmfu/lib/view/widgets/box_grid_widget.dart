
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';

class BoxGridWidget extends StatelessWidget {
  final List<GridRow> rows;
  final int nColumns;
  final bool includeColumnHeadings;

  const BoxGridWidget({Key? key, required this.rows, this.nColumns = 8, required this.includeColumnHeadings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> gridRows = [];

    if (includeColumnHeadings) {
      List<Widget> columnHeadings = [];
      for (int i=0; i<nColumns; i++) {
        columnHeadings.add(LegendCell(text: (i+1).toString(), width: 30,));
      }
      gridRows.add(Row(children: columnHeadings));
    }
    gridRows.addAll(rows.map((r) => Row(children: r.cells)));
    Widget grid = Stack(clipBehavior: Clip.none, children: [
      Positioned(
        left: 5,
        top: 5 + (includeColumnHeadings ? 30 : 0),
        child: Container(
          width: 30.0 * nColumns,
          height: 30.0 * rows.length,
          color: Colors.black,
        ),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: gridRows),
    ]);

    List<Widget> labels = [];
    if (includeColumnHeadings) {
      labels.add(const LegendCell(text: "", width: 40,));
    }
    for (int i = 0; i < rows.length; i++) {
      labels.add(LegendCell(text: rows[i].rowLabel, width: 40,));
    }
    return Row(children: [
      Column(children: labels),
      grid,
    ],);
  }
}

class GridRow {
  final String rowLabel;
  final List<Widget> cells;

  GridRow(FollowUpFormItem item, int itemIndex, void Function(BuildContext, int, int) showDialogFn)
      : cells = List.generate(8, (index) => BoxWidget(showDialogFn, item, itemIndex, index, disabled: item.disabledCells.contains(index))),
        rowLabel = createRowLabel(item);

  static String createRowLabel(FollowUpFormItem item) {
    if (item.subSection == "") {
      return "";
    }
    return "${item.section}${item.subSection}${item.subSubSection ?? ""}";
  }
}

class LegendCell extends StatelessWidget {
  final String text;
  final double width;

  const LegendCell({super.key, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, height: 30,
      child: Align(alignment: Alignment.center, child: Text(text)),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final void Function()? onRemoveComment;

  const CommentWidget({Key? key, required this.onRemoveComment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            const Text("Problem: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: TextFormField(maxLines: null,)),
          ]),
          Row(children: [
            const Text("Plan: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: TextFormField(maxLines: null)),
          ]),
          TextButton(onPressed: onRemoveComment, child: const Text("Remove Comment")),
        ],
      ),
    ));
  }
}

class BoxWidget extends StatelessWidget {
  final void Function(BuildContext, int, int) showDialogFn;
  final FollowUpFormItem item;
  final int itemIndex;
  final int followUpIndex;
  final bool disabled;

  const BoxWidget(this.showDialogFn, this.item, this.itemIndex, this.followUpIndex, {Key? key, this.disabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: disabled ? null : () {
      showDialogFn(context, itemIndex, followUpIndex);
    },child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: disabled ? Colors.grey[300] : Colors.white,
      ),
      width: 30,
      height: 30,
      child: item.questions.length > 1 ? CustomPaint(
        painter: CellPainter(),
      ) : null,
    ));
  }
}

class CellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
