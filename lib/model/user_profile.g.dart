// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      educatorID: json['educatorID'] as String?,
      programID: json['programID'] as String?,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'educatorID': instance.educatorID,
      'programID': instance.programID,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
    };
