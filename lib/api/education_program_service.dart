
import 'package:flutter/cupertino.dart';
import 'package:fmfu/model/education_program.dart';
import 'package:fmfu/utils/crud_interface.dart';
import 'package:fmfu/utils/firebase_crud_interface.dart';

class EducationProgramService extends ChangeNotifier {
  final CrudInterface<EducationProgram> _persistence;

  EducationProgramService(this._persistence);

  Stream<List<EducationProgram>> streamAll() {
    return _persistence.getAll();
  }

  Stream<EducationProgram?> stream(String id) {
    return _persistence.get(id);
  }

  Future<String> addProgram(EducationProgram program) {
    return _persistence.insert(program);
  }

  Future<void> updateProgram(EducationProgram program) {
    return _persistence.update(program);
  }

  static EducationProgramService createWithFirebase() {
    return EducationProgramService(StreamingFirebaseCrud<EducationProgram>(
      directory: "programs",
      toJson: (p) => p.toJson(),
      fromJson: EducationProgram.fromJson,
    ));
  }
}