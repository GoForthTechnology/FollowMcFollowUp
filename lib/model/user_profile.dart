

import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile extends Indexable<UserProfile> {

  final String? id;
  final String? educatorID;
  final String? programID;
  final String firstName;
  final String lastName;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.educatorID,
    required this.programID,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String fullName() {
    return "$firstName $lastName";
  }

  @override
  String? getId() {
    return id;
  }

  @override
  UserProfile setId(String id) {
    return UserProfile(id: id, firstName: firstName, lastName: lastName, programID: programID, educatorID: educatorID);
  }
}