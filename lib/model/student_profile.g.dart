// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) =>
    StudentProfile(
      id: json['id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      emailAddress: json['emailAddress'] as String,
      programId: json['programId'] as String?,
    );

Map<String, dynamic> _$StudentProfileToJson(StudentProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'programId': instance.programId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'emailAddress': instance.emailAddress,
    };
