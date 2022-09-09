import 'package:flutter/material.dart';

class CommentSectionWidget extends StatelessWidget {
  final int numRows;

  const CommentSectionWidget({Key? key, required this.numRows}) : super(key: key);

  static const headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  static const dateStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(90),
        1: FixedColumnWidth(60),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        TableRow(children: [
          _headerCell("Date", headingStyle),
          _headerCell("FU # /\nSection #", const TextStyle(fontWeight: FontWeight.bold)),
          _headerCell("Situation/Problem", headingStyle),
          _headerCell("Plan of Action", headingStyle),
        ], ),
        ...List.generate(numRows, (index) => _row()),
      ],
    );
  }

  TableCell _headerCell(String text, TextStyle style) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: Text(text, style: style),
    );
  }

  TableRow _row() {
    return TableRow(children: List.generate(4, (index) => _cell(index)));
  }

  TableCell _cell(int index) {
    return TableCell(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: SizedBox(
          height: 30,
          width: 40,
          child: index == 1 ? CustomPaint(
            painter: CellPainter(),
          ) : const Text(""),
        )
      ),
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
