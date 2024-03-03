

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/education_program.dart';
import 'package:fmfu/model/user_profile.dart';
import 'package:fmfu/utils/firebase_crud_interface.dart';
import 'package:loggy/loggy.dart';
import 'package:rxdart/rxdart.dart';

class UserService extends ChangeNotifier {

  final StreamingFirebaseCrud<UserProfile> _profilePersistence;

  UserService(this._profilePersistence);

  static UserService createWithFirebase() {
    var profilePersistence = StreamingFirebaseCrud<UserProfile>(
      directory: "users",
      fromJson: UserProfile.fromJson,
      prependUidToId: false,
      toJson: (u) => u.toJson(),
    );
    return UserService(profilePersistence);
  }

  Stream<List<UserProfile>> getStudents(EducationProgram program) {
    return FirebaseDatabase.instance
        .ref("users")
        .orderByChild("educatorID")
        .equalTo(program.educatorID)
        .onValue
        .map((e) => e.snapshot.children
            .where((s) => s.value != null)
            .map((snapshot) => snapshot.value as Map<String, dynamic>)
            .map(UserProfile.fromJson)
            .toList()).onErrorReturnWith((error, stackTrace) {
              logError("Error: $error, $stackTrace");
              return [];
    });
  }

  Stream<UserProfile> currentProfile() async* {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Not logged in!");
    }
    yield* _profilePersistence.get(user.uid).map((profile) {
      if (profile == null) {
        throw Exception("No profile found for id ${user.uid}");
      }
      return profile;
    });
  }

  Future<void> createUser(UserProfile profile) async {
    return _profilePersistence.update(profile);
  }
}