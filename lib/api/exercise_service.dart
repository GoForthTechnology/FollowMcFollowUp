
import 'package:fmfu/logic/exercises.dart';

abstract class ExerciseService {
  List<Exercise> getCustomExercises(ExerciseType exerciseType);
  bool hasCustomExercise(String name, ExerciseType exerciseType);
  void updateCustomDynamicExercise(String name, DynamicExercise exercise);
  void updateCustomStaticExercise(String name, StaticExercise exercise);
}

class RemoteExerciseService extends ExerciseService {

  @override
  List<Exercise> getCustomExercises(ExerciseType exerciseType) {
    // TODO: implement getCustomExercises
    throw UnimplementedError();
  }

  @override
  bool hasCustomExercise(String name, ExerciseType exerciseType) {
    // TODO: implement hasCustomExercise
    throw UnimplementedError();
  }

  @override
  void updateCustomDynamicExercise(String name, DynamicExercise exercise) {
    // TODO: implement updateCustomDynamicExercise
  }

  @override
  void updateCustomStaticExercise(String name, StaticExercise exercise) {
    // TODO: implement updateCustomStaticExercise
  }
}

class LocalExerciseService extends ExerciseService {
  final Map<String, StaticExercise> _customStaticExercises = {};
  final Map<String, DynamicExercise> _customDynamicExercises = {};

  @override
  List<Exercise> getCustomExercises(ExerciseType exerciseType) {
    return _getExerciseMap(exerciseType).values.toList();
  }

  @override
  bool hasCustomExercise(String name, ExerciseType exerciseType) {
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
  void updateCustomDynamicExercise(String name, DynamicExercise exercise) {
    _customDynamicExercises[name] = exercise;
  }

  @override
  void updateCustomStaticExercise(String name, StaticExercise exercise) {
    _customStaticExercises[name] = exercise;
  }
}