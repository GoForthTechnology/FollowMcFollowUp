import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_entry.dart';
import 'package:loggy/loggy.dart';

class FollowUpFormViewModel extends ChangeNotifier with GlobalLoggy {
  Map<FollowUpFormEntryId, String> entries = {};
  Map<int, List<FollowUpFormComment>> comments = {};

  String? getEntry(FollowUpFormEntryId id) {
    if (!entries.containsKey(id)) {
      return null;
    }
    return entries[id];
  }

  void updateEntry(FollowUpFormEntryId id, String? value) {
    loggy.debug("Updating $id with $value");
    if (value == null) {
      entries.remove(id);
    } else {
      entries[id] = value;
    }
    notifyListeners();
  }

  List<FollowUpFormComment> getComments(int sectionNum) {
    return comments[sectionNum] ?? [];
  }
}