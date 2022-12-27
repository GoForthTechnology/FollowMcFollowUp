
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

  static EducationProgramService createWithFirebase() {
    return EducationProgramService(StreamingFirebaseCrud<EducationProgram>(
      directory: "programs",
      toJson: (p) => p.toJson(),
      fromJson: EducationProgram.fromJson,
    ));
  }
}