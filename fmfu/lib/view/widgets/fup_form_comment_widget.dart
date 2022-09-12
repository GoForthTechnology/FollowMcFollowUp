
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';

class CommentWidget extends StatelessWidget {
  final FollowUpFormItem item;
  final int followUpIndex;

  final void Function()? onRemoveComment;

  const CommentWidget({
    Key? key,
    required this.onRemoveComment,
    required this.item,
    required this.followUpIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            const Text("Problem: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: TextFormField(maxLines: null,)),
          ]),
          Row(children: [
            const Text("Plan: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: TextFormField(maxLines: null)),
          ]),
          TextButton(onPressed: onRemoveComment, child: const Text("Remove Comment")),
        ],
      ),
    ));
  }
}
