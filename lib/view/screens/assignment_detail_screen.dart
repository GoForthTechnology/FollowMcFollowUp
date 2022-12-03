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
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600), child: ListView.builder(
        itemBuilder: (context, index) => _questionWidget(assignment.questions[index]),
        itemCount: assignment.questions.length,
      ))),
    );
  }

  Widget _questionWidget(Question question) {
    if (question is MultipleChoiceQuestion) {
      return MultipleChoiceWidget(question: question);
    }
    throw Exception();
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