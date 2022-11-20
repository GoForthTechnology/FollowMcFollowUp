
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fmfu/logic/exercises.dart';

abstract class ExerciseService {
  Future<List<Exercise>> getCustomExercises(ExerciseType exerciseType);
  Future<bool> hasCustomExercise(String name, ExerciseType exerciseType);
  Future<void> removeExercise(String name, ExerciseType exerciseType);
  Future<void> updateCustomDynamicExercise(String name, DynamicExercise exercise);
  Future<void> updateCustomStaticExercise(String name, StaticExercise exercise);

  static ExerciseService create(User? currentUser) {
    if (currentUser != null) {
      return RemoteExerciseService(currentUser);
    }
    return LocalExerciseService();
  }
}

class RemoteExerciseService extends ExerciseService {

  final User currentUser;

  RemoteExerciseService(this.currentUser);

  DatabaseReference _ref(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.static:
        return FirebaseDatabase.instance.ref("exercises/static/${currentUser.uid}");
      case ExerciseType.dynamic:
        return FirebaseDatabase.instance.ref("exercises/dynamic/${currentUser.uid}");
    }
  }

  @override
  Future<List<Exercise>> getCustomExercises(ExerciseType exerciseType) async {
    var snapshot = await _ref(exerciseType).get();
    switch (exerciseType) {
      case ExerciseType.static:
        return snapshot.children.map((child) {
          var json = child.value as Map<String, dynamic>;
          return StaticExercise.fromJson(json);
        }).toList();
      case ExerciseType.dynamic:
        return snapshot.children.map((child) {
          var json = child.value as Map<String, dynamic>;
          return DynamicExercise.fromJson(json);
        }).toList();
    }
  }

  @override
  Future<bool> hasCustomExercise(String name, ExerciseType exerciseType) async {
    var snapshot = await _ref(exerciseType).get();
    return snapshot.hasChild(name);
  }

  @override
  Future<void> updateCustomDynamicExercise(String name, DynamicExercise exercise) async {
    return _ref(ExerciseType.dynamic)
        .child(name)
        .set(exercise.toJson());
  }

  @override
  Future<void> updateCustomStaticExercise(String name, StaticExercise exercise) {
    return _ref(ExerciseType.static)
        .child(name)
        .set(exercise.toJson());
  }

  @override
  Future<void> removeExercise(String name, ExerciseType exerciseType) {
    return _ref(exerciseType).child(name).remove();
  }
}

class LocalExerciseService extends ExerciseService {
  final Map<String, StaticExercise> _customStaticExercises = {};
  final Map<String, DynamicExercise> _customDynamicExercises = {};

  @override
  Future<List<Exercise>> getCustomExercises(ExerciseType exerciseType) async {
    return _getExerciseMap(exerciseType).values.toList();
  }

  @override
  Future<bool> hasCustomExercise(String name, ExerciseType exerciseType) async {
    return _getExerciseMap(exerciseType).containsKey(name);
  }

  Map<String, Exercise> _getExerciseMap(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.static:
        return _customStaticExercises;
      case ExerciseType.dynamic:
        return _customDynamicExercises;
    }
  }

  @override
  Future<void> updateCustomDynamicExercise(String name, DynamicExercise exercise) async {
    _customDynamicExercises[name] = exercise;
  }

  @override
  Future<void> updateCustomStaticExercise(String name, StaticExercise exercise) async {
    _customStaticExercises[name] = exercise;
  }

  @override
  Future<void> removeExercise(String name, ExerciseType exerciseType) async {
    _getExerciseMap(exerciseType).remove(name);
  }
}