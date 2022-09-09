
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';

class BoxGridWidget extends StatelessWidget {
  final List<GridRow> rows;
  final int nColumns;

  const BoxGridWidget({Key? key, required this.rows, this.nColumns = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> gridRows = [];

    List<Widget> columnHeadings = [];
    for (int i=0; i<nColumns; i++) {
      columnHeadings.add(LegendCell(text: (i+1).toString()));
    }
    gridRows.add(Row(children: columnHeadings));
    gridRows.addAll(rows.map((r) => Row(children: r.cells)));
    Widget grid = Stack(clipBehavior: Clip.none, children: [
      Positioned(
        left: 5,
        top: 35,
        child: Container(
          width: 30.0 * nColumns,
          height: 30.0 * rows.length,
          color: Colors.black,
        ),
      ),
      Column(children: gridRows),
    ]);

    List<Widget> labels = [];
    labels.add(const LegendCell(text: ""));
    for (int i = 0; i < rows.length; i++) {
      labels.add(LegendCell(text: rows[i].rowLabel));
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

  GridRow(FollowUpFormItem item)
      : cells = List.generate(8, (index) => BoxWidget(item, index, disabled: item.disabledCells.contains(index), split: item.splitBoxes)),
    rowLabel = "${item.section}${item.subSection}";
}

class LegendCell extends StatelessWidget {
  final String text;

  const LegendCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30, height: 30,
      child: Center(child: Text(text)),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(children: [
        Row(children: [
          const Text("Problem: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: TextFormField(maxLines: null,)),
        ]),
        Row(children: [
          const Text("Plan: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: TextFormField(maxLines: null)),
        ]),
      ]),
    ));
  }
}

class BoxWidget extends StatelessWidget {
  final FollowUpFormItem item;
  final int index;
  final bool disabled;
  final bool split;

  const BoxWidget(this.item, this.index, {Key? key, this.disabled = false, this.split = false}) : super(key: key);

  List<Widget> getQuestionRows(Question question, Function(String?) onPressed) {
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

  List<Widget> getItemRows(FollowUpFormItem item, Function(String?) onPressed) {
    return item.questions.map((q) => getQuestionRows(q, onPressed)).expand((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: disabled ? null : () {
      showDialog(context: context, builder: (BuildContext context) {
        String? selectedItem;
        List<String> comments = [];
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
                "Section: ${item.section}${item.subSection} - ${index + 1}"),
            content: IntrinsicHeight(child: SizedBox(width: 300, child: Column(children: [
              ...getItemRows(item, (item) {
                setState(() {
                  selectedItem = item;
                });
              }),
              // TODO: fix issue when too many comments are added
              ...comments.map((comment) => const CommentWidget()).toList(),
              Padding(padding: const EdgeInsets.all(2), child: ElevatedButton(
                onPressed: () => setState(() {
                  comments.add("");
                }),
                child: const Text("Add Comment"),
              )),
            ]))),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: const Text("Ok"),),
            ],
          );
        });
      });
    },child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: disabled ? Colors.grey : Colors.white,
      ),
      width: 30,
      height: 30,
      child: split ? CustomPaint(
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
