

import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile extends Indexable<UserProfile> {

  final String id;
  final String firstName;
  final String lastName;
  final String emailAddress;

  final String? educationProgramName;

  UserProfile({required this.id, required this.firstName, required this.lastName, required this.emailAddress, this.educationProgramName });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  bool isAnEducator() {
    return educationProgramName != null;
  }

  @override
  String? getId() {
    return id;
  }

  @override
  UserProfile setId(String id) {
    // This is a hack and an abuse of the Indexable interface.
    // Doing this to enable the use of the StreamingCrud interface...
    return this;
  }
}