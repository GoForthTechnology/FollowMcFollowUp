
import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'education_program.g.dart';

@JsonSerializable(explicitToJson: true)
class EducationProgram extends Indexable<EducationProgram> {
  final String? id;
  final String name;
  final String educatorID;


  EducationProgram(this.name, this.id, this.educatorID);

  factory EducationProgram.fromJson(Map<String, dynamic> json) => _$EducationProgramFromJson(json);
  Map<String, dynamic> toJson() => _$EducationProgramToJson(this);

  @override
  String? getId() {
    return id;
  }

  @override
  EducationProgram setId(String id) {
    return EducationProgram(name, id, educatorID);
  }
}