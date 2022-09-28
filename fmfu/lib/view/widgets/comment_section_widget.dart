import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loggy/loggy.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';


class CommentSectionWidget extends StatelessWidget with UiLoggy {
  final int numRows;
  final ItemId previousItemId;
  final ItemId? nextItemId;
  final int numPreviousCommentRows;

  const CommentSectionWidget({
    Key? key,
    required this.numRows,
    required this.previousItemId,
    required this.nextItemId,
    required this.numPreviousCommentRows,
  }) : super(key: key);

  static CommentSectionWidget create(
      int numRows,
      List<FollowUpFormItem> previousItems,
      List<FollowUpFormItem> nextItems,
      {int numPreviousCommentRows = 0}) {
    return CommentSectionWidget(
      numRows: numRows,
      previousItemId: previousItems.map((i) => i.id()).first,
      nextItemId: nextItems.map((i) => i.id()).firstOrNull,
      numPreviousCommentRows: numPreviousCommentRows,
    );
  }

  static const headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  static const dateStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Consumer<FollowUpFormViewModel>(builder: (context, model, child) {
      var comments = model.getCommentsForSection(previousItemId, nextItemId);
      loggy.debug("Got ${comments.length} comments");
      var commentRowData = comments
          .map((comment) => CommentRowData.fromComment(comment))
          .expand((i) => i)
          .toList();
      loggy.debug("Got ${commentRowData.length} row models");
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
          ...List.generate(numRows, (index) => _row(index, commentRowData)),
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
      print("Row Data: " + rowData.problemLines.join("\n"));
      return rowData.problemLines.join("\n");
    }
    if (index == 3) {
      return rowData.planLines.join("\n");
    }
    throw Exception();
  }
}

class CommentRowData {
  final String? date;
  final String? followUpNumber;
  final String? sectionCode;
  final List<String> problemLines;
  final List<String> planLines;

  CommentRowData(this.date, this.followUpNumber, this.sectionCode, this.problemLines, this.planLines);

  static List<CommentRowData> fromComment(FollowUpFormComment comment) {
    List<String> clamp(String foo) {
      foo = foo.replaceAll("\n", " ");

      List<String> lines = [];
      var words = foo.split(" ");
      String line = "";
      for (var word in words) {
        if (line.length > 70) {
          throw Exception("Line $line is too long");
        }
        if (line.length + word.length + 1 < 71) {
          line += "$word ";
        } else {
          if (line.isNotEmpty) {
            lines.add(line);
          }
          line = "$word ";
        }
      }
      if (line.isNotEmpty) {
        lines.add(line);
      }
      return lines;
    }
    List<List<String>> pair(List<String> lines) {
      List<List<String>> out = [];
      List<String> pair = [];
      for (var line in lines) {
        print("Processing line: $line");
        if (pair.length == 2) {
          out.add(pair);
          pair = [];
        }
        pair.add(line);
      }
      if (pair.isNotEmpty) {
        out.add(pair);
      }
      return out;
    }
    var problemLinePairs = pair(clamp(comment.problem));
    var planLinePairs = pair(clamp(comment.planOfAction));
    List<CommentRowData> out = [];
    while (planLinePairs.isNotEmpty || problemLinePairs.isNotEmpty) {
      List<String> problemLines = [];
      if (problemLinePairs.isNotEmpty) {
        problemLines = problemLinePairs.first;
        problemLinePairs.removeAt(0);
      }
      List<String> planLines = [];
      if (planLinePairs.isNotEmpty) {
        planLines = planLinePairs.first;
        planLinePairs.removeAt(0);
      }
      if (out.isEmpty) {
        out.add(CommentRowData(
          DateFormat("yyyy-MM-dd").format(comment.date),
          comment.id.index.toString(),
          comment.id.boxId.itemId.code,
          problemLines,
          planLines,
        ));
      } else {
        out.add(CommentRowData(
          null,
          null,
          null,
          problemLines,
          planLines,
        ));
      }
    }
    return out;
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
