

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/educator_profile.dart';
import 'package:fmfu/model/student_profile.dart';
import 'package:fmfu/model/user_profile.dart';
import 'package:fmfu/utils/crud_interface.dart';
import 'package:fmfu/utils/firebase_crud_interface.dart';

class UserService extends ChangeNotifier {

  final CrudInterface<EducatorProfile> _educatorPersistence;
  final CrudInterface<StudentProfile> _studentPersistence;
  final CrudInterface<UserProfile> _profilePersistence;

  UserService(this._educatorPersistence, this._studentPersistence, this._profilePersistence);

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
    var profilePersistence = StreamingFirebaseCrud<UserProfile>(
      directory: "users",
      fromJson: UserProfile.fromJson,
      prependUidToId: false,
      toJson: (u) => u.toJson(),
    );
    return UserService(educatorPersistence, studentPersistence, profilePersistence);
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

  Stream<EducatorProfile> currentEducator() async* {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Not logged in!");
    }
    yield* _educatorPersistence.get(user.uid).map((educator) {
      if (educator == null) {
        throw Exception("No educator found for id ${user.uid}");
      }
      return educator;
    });
  }

  Stream<List<StudentProfile>> getAllStudents({String? programId, bool includeUnEnrolled = false}) {
    return _studentPersistence.getAll().map((students) => students.where((s) {
      if (s.programId == null && includeUnEnrolled) {
        return true;
      }
      if (programId != null && s.programId != programId) {
        return false;
      }
      return true;
    }).toList());
  }

  Future<void> updateStudent(StudentProfile studentProfile) {
    return _studentPersistence.update(studentProfile);
  }

  Future<void> createStudent(StudentProfile studentProfile) {
    return _studentPersistence.update(studentProfile);
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

  Future<void> createUser(UserProfile profile) async {
    return _profilePersistence.update(profile);
  }
}