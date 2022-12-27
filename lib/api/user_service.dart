

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/educator_profile.dart';
import 'package:fmfu/model/student_profile.dart';
import 'package:fmfu/utils/crud_interface.dart';
import 'package:fmfu/utils/firebase_crud_interface.dart';

class UserService extends ChangeNotifier {

  final CrudInterface<EducatorProfile> _educatorPersistence;
  final CrudInterface<StudentProfile> _studentPersistence;

  UserService(this._educatorPersistence, this._studentPersistence);

  static UserService createWithFirebase() {
    var educatorPersistence = StreamingFirebaseCrud<EducatorProfile>(
        directory: "educators",
        toJson: (u) => u.toJson(),
        fromJson: EducatorProfile.fromJson,
        prependUidToId: false
    );
    var studentPersistence = StreamingFirebaseCrud<StudentProfile>(
        directory: "students",
        toJson: (u) => u.toJson(),
        fromJson: StudentProfile.fromJson,
    );
    return UserService(educatorPersistence, studentPersistence);
  }

  Stream<List<StudentProfile>> getAllStudents() {
    return _studentPersistence.getAll();
  }

  Future<EducatorProfile> getOrCreateEducatorProfile() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in!");
    }
    var profile = await _educatorPersistence.get(currentUser.uid).first;
    if (profile != null) {
      return profile;
    }

    profile = EducatorProfile(
      id: currentUser.uid,
      firstName: currentUser.displayName ?? "",
      lastName: "",
      emailAddress: currentUser.email ?? "",
      educationProgramName: 'foo',
    );
    await _educatorPersistence.update(profile);
    return profile;
  }
}