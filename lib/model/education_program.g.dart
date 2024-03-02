// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationProgram _$EducationProgramFromJson(Map<String, dynamic> json) =>
    EducationProgram(
      json['name'] as String,
      json['id'] as String?,
      json['educatorID'] as String,
      const LocalDateJsonConverter().fromJson(json['ep1Date'] as int),
      const LocalDateJsonConverter().fromJson(json['ep2Date'] as int),
      enrolledStudentIds: (json['enrolledStudentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assignments: (json['assignments'] as List<dynamic>?)
              ?.map((e) => Assignment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EducationProgramToJson(EducationProgram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'educatorID': instance.educatorID,
      'enrolledStudentIds': instance.enrolledStudentIds,
      'assignments': instance.assignments.map((e) => e.toJson()).toList(),
      'ep1Date': const LocalDateJsonConverter().toJson(instance.ep1Date),
      'ep2Date': const LocalDateJsonConverter().toJson(instance.ep2Date),
    };
