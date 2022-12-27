
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_machine/time_machine.dart';

part 'education_program.g.dart';

@JsonSerializable(explicitToJson: true)
class EducationProgram extends Indexable<EducationProgram> {
  final String? id;
  final String name;

  final List<String> enrolledStudentIds;

  @LocalDateJsonConverter()
  final LocalDate ep1Date;
  @LocalDateJsonConverter()
  final LocalDate ep2Date;

  EducationProgram(this.name, this.id, this.ep1Date, this.ep2Date, {this.enrolledStudentIds = const []});

  factory EducationProgram.fromJson(Map<String, dynamic> json) => _$EducationProgramFromJson(json);
  Map<String, dynamic> toJson() => _$EducationProgramToJson(this);

  @override
  String? getId() {
    return id;
  }

  @override
  EducationProgram setId(String id) {
    return EducationProgram(name, id, ep1Date, ep2Date, enrolledStudentIds: enrolledStudentIds);
  }
}