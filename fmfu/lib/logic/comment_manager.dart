import 'dart:collection';

import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_layout.dart';
import 'package:intl/intl.dart';

class CommentManager {
  final List<FollowUpFormComment> comments;
  CommentLayout commentLayout;

  CommentManager(this.comments) : commentLayout = CommentLayout.forComments(comments);

  void addComment(FollowUpFormComment comment) {
    comments.add(comment);
    commentLayout = CommentLayout.forComments(comments);
  }

}


class CommentLayout {
  final Map<int, List<CommentRowData>> rowData;

  CommentLayout(this.rowData);

  List<CommentRowData> getCommentsForPage(int pageNum) {
    return rowData[pageNum] ?? [];
  }

  static CommentLayout forComments(List<FollowUpFormComment> comments) {
    Map<int, List<CommentRowData>> out = {};
    if (comments.isEmpty) {
      return CommentLayout(out);
    }

    comments.sort((a, b) => a.compareTo(b));
    Queue<FollowUpFormComment> commentQueue = Queue()
      ..addAll(comments);

    FollowUpFormLayout.commentConfigs.forEach((page, config) {
      if (commentQueue.isEmpty) {
        return;
      }
      while (commentQueue.isNotEmpty && (
          config.lastItemIdExclusive == null ||
              config.lastItemIdExclusive! > commentQueue.first.itemId)) {
        var rowDatas = out[page] ?? [];
        rowDatas.addAll(CommentRowData.fromComment(commentQueue.removeFirst()));
        out[page] = rowDatas;
      }
      return;
    });

    return CommentLayout(out);
  }
}

class CommentRowData {
  final String? date;
  final String? followUpNumber;
  final String? sectionCode;
  final List<String> problemLines;
  final List<String> planLines;

  CommentRowData({this.date, this.followUpNumber, this.sectionCode, this.problemLines = const [], this.planLines = const []});

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
          date: DateFormat("yyyy-MM-dd").format(comment.date),
          followUpNumber: comment.id.boxId.followUp.toString(),
          sectionCode: comment.id.boxId.itemId.code,
          planLines: planLines,
          problemLines: problemLines,
        ));
      } else {
        out.add(CommentRowData(
          problemLines: problemLines,
          planLines: planLines,
        ));
      }
    }
    return out;
  }
}
