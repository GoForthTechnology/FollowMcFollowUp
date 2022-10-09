
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/view_model/fup_form_view_model.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget with SaveItem {
  final CommentId commentId;
  final formKey = GlobalKey<FormState>();

  CommentWidget({
    Key? key,
    required item,
    required followUpIndex,
    required commentIndex,
  }) : commentId = CommentId(
      index: commentIndex,
      boxId: BoxId(
        followUp: followUpIndex,
        itemId: item.id(),
      ),
    ), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Consumer<FollowUpFormViewModel>(builder: (context, model, child) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              const Text("Problem: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: TextFormField(maxLines: null, onSaved: (value) {
                model.updateCommentProblem(commentId, value ?? "");
              }, initialValue: model.getComment(commentId)!.problem)),
            ]),
            Row(children: [
              const Text("Plan: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: TextFormField(maxLines: null, onSaved: (value) {
                model.updateCommentPlan(commentId, value ?? "");
              }, initialValue: model.getComment(commentId)!.planOfAction)),
            ]),
            TextButton(onPressed: () => model.removeComment(commentId), child: const Text("Remove Comment")),
          ],
        ),
      ),
    )));
  }

  @override
  void save() {
    formKey.currentState?.save();
  }
}

abstract class SaveItem {
  void save();
}
