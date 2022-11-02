
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/program.dart';

class ProgramListViewModel extends ChangeNotifier {
  final List<Program> programs = [];

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