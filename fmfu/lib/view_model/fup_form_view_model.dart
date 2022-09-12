import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_entry.dart';
import 'package:loggy/loggy.dart';

class FollowUpFormViewModel extends ChangeNotifier with GlobalLoggy {
  Map<FollowUpFormEntryId, String> entries = {};

  String? get(FollowUpFormEntryId id) {
    loggy.debug("Getting value for $id");
    if (!entries.containsKey(id)) {
      return null;
    }
    return entries[id];
  }

  void update(FollowUpFormEntryId id, String? value) {
    loggy.debug("Updating $id with $value");
    if (value == null) {
      entries.remove(id);
    } else {
      entries[id] = value;
    }
    notifyListeners();
  }
}