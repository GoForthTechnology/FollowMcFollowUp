

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/user_profile.dart';
import 'package:fmfu/utils/crud_interface.dart';

class UserService extends ChangeNotifier {

  final CrudInterface _persistence;

  UserService(this._persistence);

  Future<UserProfile> getOrCreateProfile() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in!");
    }
    var profile = await _persistence.get(currentUser.uid).first;
    if (profile != null) {
      return profile;
    }

    profile = UserProfile(
      id: currentUser.uid,
      firstName: currentUser.displayName ?? "",
      lastName: "",
      emailAddress: currentUser.email ?? "",
    );
    await _persistence.update(profile);
    return profile;
  }
}