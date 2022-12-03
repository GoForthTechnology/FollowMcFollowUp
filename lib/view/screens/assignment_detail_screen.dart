import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/assignment.dart';

class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({super.key, @pathParam required this.id, required this.assignment});

  final int id;
  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment #$id"),
      ),
      body: LayoutBuilder(builder: (context , constraints ) => Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600), child: CustomScrollView(
        slivers: [
          _makeGrid(assignment.questions, constraints),
          // TODO: move this to the assignment
          _makeHeader(const Text("The following 5 cycles (A-E) represent examples for which the following questions will apply. For examples A-D, you can assume good observations and charting. For example E, the questions will relate to the chart correcting of that cycle. ")),
        ],
      ))),
    ));
  }

  Widget _questionWidget(Question question) {
    if (question is MultipleChoiceQuestion) {
      return MultipleChoiceWidget(question: question);
    }
    throw Exception();
  }

  Widget _makeGrid(List<Question> questions, BoxConstraints constraints) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) => _questionWidget(questions[index]), childCount: questions.length),
    );
  }
}

class MultipleChoiceWidget extends StatefulWidget {
  final MultipleChoiceQuestion question;

  const MultipleChoiceWidget({super.key, required this.question});

  @override
  State<StatefulWidget> createState() => MultipleChoiceState();
}

class MultipleChoiceState extends State<MultipleChoiceWidget> {
  String? answer;

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [];
    options.addAll(widget.question.options
        .map((key, value) => MapEntry(key, RadioListTile<String>(
          onChanged: (v) => setState(() => answer = v),
          value: key,
          groupValue: answer,
          title: Text("$key. $value"),
        )))
        .values
        .toList());
    const style = TextStyle(fontSize: 18);
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.question.number}. ", style: style,),
            Flexible(child: Text(widget.question.question, style: style,)),
          ],
        ),
        ...options.map((widget) => Padding(padding: const EdgeInsets.only(left: 20), child: widget)).toList(),
      ],
    ));
  }
}

SliverPersistentHeader _makeHeader(Widget child) {
  return SliverPersistentHeader(
    delegate: _SliverAppBarDelegate(
      minHeight: 60.0,
      maxHeight: 60.0,
      child: child,
    ),
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
