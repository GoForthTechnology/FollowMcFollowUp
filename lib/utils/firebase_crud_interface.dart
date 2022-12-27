import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'crud_interface.dart';

class StreamingFirebaseCrud<T extends Indexable> extends CrudInterface<T> {
  final String directory;
  final FirebaseDatabase db;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final userCompleter = Completer<User>();
  final bool prependUidToId;

  StreamingFirebaseCrud({required this.directory, required this.fromJson, required this.toJson, this.prependUidToId = true}) : db = FirebaseDatabase.instance {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((user) {
      if (user != null) {
        userCompleter.complete(user);
        notifyListeners();
      }
    });
  }

  Future<String?> _ref({String? id}) async {
    var user = await userCompleter.future;
    var ref = "$directory/${user.uid}";
    if (prependUidToId && id != null) {
      ref = "$ref/$id";
    }
    return ref;
  }

  @override
  Stream<T?> get(String id) async* {
    var ref = await _ref(id: id);
    print(ref);
    yield* db.ref(ref).onValue
        .map((e) {
          if (e.snapshot.value == null) {
            return null;
          }
          return fromJson(e.snapshot.value as Map<String, dynamic>);
        });
  }

  @override
  Stream<List<T>> getAll() async* {
    var ref = await _ref(id: null);
    yield* db.ref(ref).onValue
        .map((e) => e.snapshot.children
        .map((snapshot) => snapshot.value as Map<String, dynamic>)
        .map(fromJson)
        .toList());
  }

  @override
  Future<String> insert(T t) async {
    var ref = await _ref(id: null);
    var child = db.ref(ref).push();
    var id = child.key!;
    var ut = t.setId(id);
    return child.set(toJson(ut)).then((_) => id);
  }

  @override
  Future<void> remove(String id) async {
    var ref = await _ref(id: id);
    return db.ref(ref).remove();
  }

  @override
  Future<void> update(T t) async {
    if (t.getId() == null) {
      return insert(t).then((id) {
        t.setId(id);
      });
    }
    var ref = await _ref(id: t.getId());
    return db.ref(ref).set(toJson(t));
  }
}
