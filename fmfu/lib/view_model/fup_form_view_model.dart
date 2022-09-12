import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_entry.dart';

class FollowUpFormViewModel extends ChangeNotifier {
  Map<FollowUpFormEntryId, String> entries = {};

  String? get(FollowUpFormEntryId id) {
    if (!entries.containsKey(id)) {
      return null;
    }
    return entries[id];
  }

  void update(FollowUpFormEntryId id, String? value) {
    if (value == null) {
      entries.remove(id);
    } else {
      entries[id] = value;
    }
  }
}