import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;


class CommentSectionWidget extends StatelessWidget {
  final int numRows;
  final List<FollowUpFormComment> comments;

  const CommentSectionWidget({Key? key, required this.numRows, required this.comments}) : super(key: key);

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
        ...List.generate(numRows, (index) => _row(index)),
      ],
    );
  }

  TableCell _headerCell(String text, TextStyle style) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: Center(child: Text(text, style: style)),
    );
  }

  TableRow _row(int rowIndex) {
    var comment = rowIndex < 0 || rowIndex > comments.length - 1 ? null : comments[rowIndex];
    return TableRow(children: List.generate(4, (columnIndex) => _cell(comment, columnIndex)));
  }

  TableCell _cell(FollowUpFormComment? comment, int columnIndex) {
    return TableCell(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: SizedBox(
          height: 30,
          width: 40,
          child: columnIndex == 1 ? CustomPaint(
            painter: CellPainter(comment),
          ) : Padding(padding: const EdgeInsets.all(4), child: Text(getText(comment, columnIndex))),
        )
      ),
    );
  }

  static String getText(FollowUpFormComment? comment, int index) {
    if (comment == null) {
      return "";
    }
    if (index == 0) {
      return DateFormat("yyyy-MM-dd").format(comment.date);
    }
    if (index == 1) {
      return "";
    }
    if (index == 2) {
      return comment.problem;
    }
    if (index == 3) {
      return comment.planOfAction;
    }
    throw Exception();
  }
}

class CellPainter extends CustomPainter {
  final FollowUpFormComment? comment;

  CellPainter(this.comment);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);

    if (comment != null) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: comment!.followUpNum.toString(),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(10, 0));

      TextPainter sectionPainter = TextPainter(
        text: TextSpan(
          text: comment!.sectionNum.toString(),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      sectionPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      sectionPainter.paint(canvas, Offset(size.width - 20, 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}