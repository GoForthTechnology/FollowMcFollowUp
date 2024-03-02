import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/education_program.dart';

class EnrollmentService extends ChangeNotifier {

  final FirebaseDatabase db = FirebaseDatabase.instance;

  Future<void> add(EducationProgram program) async {
    return _ref(program.id!).set(program.educatorID);
  }

  Future<void> remove(EducationProgram program) async {
    return _ref(program.id!).remove();
  }

  Stream<String?> contains(String id) async* {
    yield* _ref(id).onValue.map((e) {
      if (!e.snapshot.exists) {
        return null;
      }
      return e.snapshot.value as String;
    });
  }

  DatabaseReference _ref(String id) {
    return db.ref("enrollments/$id");
  }
}