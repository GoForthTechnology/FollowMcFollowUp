import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class EnrollmentService extends ChangeNotifier {

  final FirebaseDatabase db = FirebaseDatabase.instance;

  Future<void> add(String id) async {
    return db.ref("enrollments/$id").set(true);
  }

  Future<void> remove(String id) async {
    return db.ref("enrollments/$id").remove();
  }

  Stream<bool> contains(String id) async* {
    yield* _ref(id).onValue.map((e) {
      return e.snapshot.exists;
    });
  }

  DatabaseReference _ref(String id) {
    return db.ref("enrollments/$id");
  }
}