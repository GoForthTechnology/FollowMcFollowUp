// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationProgram _$EducationProgramFromJson(Map<String, dynamic> json) =>
    EducationProgram(
      json['name'] as String,
      json['id'] as String?,
      const LocalDateJsonConverter().fromJson(json['ep1Date'] as int),
      const LocalDateJsonConverter().fromJson(json['ep2Date'] as int),
      enrolledStudentIds: (json['enrolledStudentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EducationProgramToJson(EducationProgram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enrolledStudentIds': instance.enrolledStudentIds,
      'ep1Date': const LocalDateJsonConverter().toJson(instance.ep1Date),
      'ep2Date': const LocalDateJsonConverter().toJson(instance.ep2Date),
    };
