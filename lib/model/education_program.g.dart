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
    );

Map<String, dynamic> _$EducationProgramToJson(EducationProgram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'educatorID': instance.educatorID,
    };
