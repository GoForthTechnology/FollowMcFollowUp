import 'package:flutter/material.dart';
import 'package:fmfu/logic/comment_manager.dart';
import 'package:fmfu/model/fup_form_layout.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class CommentSectionWidget extends StatelessWidget with UiLoggy {
  final int pageNum;
  late CommentSectionConfig commentConfig;

  CommentSectionWidget({
    Key? key,
    required this.pageNum,
  }) : super(key: key) {
    commentConfig = FollowUpFormLayout.commentConfigForPage(pageNum)!;
  }

  static const headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  static const dateStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Consumer<FollowUpFormViewModel>(builder: (context, model, child) {
      var commentRowData = model.getCommentsForPage(pageNum);
      return Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FixedColumnWidth(60),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        children: [
          TableRow(children: [
            _headerCell("Date", headingStyle),
            _headerCell("FU # /\nSection #",
                const TextStyle(fontWeight: FontWeight.bold)),
            _headerCell("Situation/Problem", headingStyle),
            _headerCell("Plan of Action", headingStyle),
          ],),
          ...List.generate(commentConfig.numRows, (index) => _row(index, commentRowData)),
        ],
      );
    });
  }

  TableCell _headerCell(String text, TextStyle style) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: Center(child: Text(text, style: style)),
    );
  }

  TableRow _row(int rowIndex, List<CommentRowData> rowData) {
    var comment = rowIndex < 0 || rowIndex > rowData.length - 1 ? null : rowData[rowIndex];
    return TableRow(children: List.generate(4, (columnIndex) => _cell(comment, columnIndex)));
  }

  Widget _cell(CommentRowData? rowData, int columnIndex) {
    TextStyle? style;
    if (columnIndex > 0) {
      style = TextStyle(
        fontSize: 9,
        fontFamily: GoogleFonts.sourceCodePro().fontFamily,
      );
    }
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: columnIndex == 1 ? SizedBox(
        height: 30,
        width: 40,
        child: CustomPaint(painter: CellPainter(rowData)),
      ) : ConstrainedBox(constraints: const BoxConstraints(minHeight: 30), child: Padding(padding: const EdgeInsets.all(4), child: SelectableText(
        getText(rowData, columnIndex),
        style: style,
        textAlign: columnIndex == 0 ? TextAlign.center : null,),
      )),
    );
  }

  static String getText(CommentRowData? rowData, int index) {
    if (rowData == null) {
      return "";
    }
    if (index == 0) {
      return rowData.date ?? "";
    }
    if (index == 1) { // Deferred to CellPainter
      return "";
    }
    if (index == 2) {
      return rowData.problemLines.join("\n");
    }
    if (index == 3) {
      return rowData.planLines.join("\n");
    }
    throw Exception();
  }
}

class CellPainter extends CustomPainter {
  final CommentRowData? rowData;

  CellPainter(this.rowData);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
    _paintFollowUpNumber(canvas, size);
    _paintSection(canvas, size);
  }

  void _paintSection(Canvas canvas, Size size) {
    if (rowData == null) {
      return;
    }
    TextPainter sectionPainter = TextPainter(
      text: TextSpan(
        text: rowData?.sectionCode ?? "",
      ),
      textDirection: ui.TextDirection.ltr,
    );
    sectionPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    sectionPainter.paint(canvas, Offset(size.width - 20, 10));
  }

  void _paintFollowUpNumber(Canvas canvas, Size size) {
    if (rowData == null) {
      return;
    }
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: rowData?.followUpNumber ?? "",
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, const Offset(10, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
