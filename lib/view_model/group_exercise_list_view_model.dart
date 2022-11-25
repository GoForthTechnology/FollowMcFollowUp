
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fmfu/api/exercise_service.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/model/program.dart';

class GroupExerciseListViewModel extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService.create(FirebaseAuth.instance.currentUser);

  final List<Program> programs = [];

  Future<List<Exercise>> getExercises() {
    return _exerciseService.getCustomExercises(ExerciseType.dynamic);
  }

  void addProgram(Program program) {
    programs.add(program);
    notifyListeners();
  }

  void updateProgram(int index, Program program) {
    programs.insert(index, program);
    notifyListeners();
  }

  void removeProgram(int index) {
    programs.removeAt(index);
    notifyListeners();
  }
}