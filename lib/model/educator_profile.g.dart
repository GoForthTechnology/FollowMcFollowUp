// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'educator_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducatorProfile _$EducatorProfileFromJson(Map<String, dynamic> json) =>
    EducatorProfile(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      emailAddress: json['emailAddress'] as String,
      educationProgramName: json['educationProgramName'] as String,
    );

Map<String, dynamic> _$EducatorProfileToJson(EducatorProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'emailAddress': instance.emailAddress,
      'educationProgramName': instance.educationProgramName,
    };
