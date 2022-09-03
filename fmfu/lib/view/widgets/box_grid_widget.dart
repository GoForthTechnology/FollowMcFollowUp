
import 'package:flutter/material.dart';

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

  GridRow(this.rowLabel, {Set<int> disabledCells = const {}, bool splitCells = false})
      : cells = List.generate(8, (index) => BoxWidget(
    disabled: disabledCells.contains(index),
    split: splitCells,
  ));
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

class BoxWidget extends StatelessWidget {
  final bool disabled;
  final bool split;
  const BoxWidget({Key? key, this.disabled = false, this.split = false}) : super(key: key);

  static Row createRow({int length=8}) {
    List<Widget> cells = [];
    for (int i=0; i<length; i++) {
      cells.add(const BoxWidget());
    }
    return Row(children: cells);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: disabled ? Colors.grey : Colors.white,
      ),
      width: 30,
      height: 30,
      child: split ? CustomPaint(
        painter: CellPainter(),
      ) : null,
    );
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
