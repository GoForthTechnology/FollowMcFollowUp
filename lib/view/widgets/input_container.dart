import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  final String? title;
  final Widget content;

  const InputContainer({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        title == null ? Container() : Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: Text(title!, style: Theme.of(context).textTheme.titleSmall),
        ),
        content,
      ]),
    );
  }
}