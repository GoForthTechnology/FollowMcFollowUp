

import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'educator_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class EducatorProfile extends Indexable<EducatorProfile> {

  final String id;
  final String firstName;
  final String lastName;
  final String emailAddress;

  final String educationProgramName;

  EducatorProfile({required this.id, required this.firstName, required this.lastName, required this.emailAddress, required this.educationProgramName });

  factory EducatorProfile.fromJson(Map<String, dynamic> json) => _$EducatorProfileFromJson(json);
  Map<String, dynamic> toJson() => _$EducatorProfileToJson(this);

  @override
  String toString() {
    return "Educator (email: $emailAddress, firstName: $firstName, lastName: $lastName)";
  }

  @override
  String? getId() {
    return id;
  }

  @override
  EducatorProfile setId(String id) {
    // This is a hack and an abuse of the Indexable interface.
    // Doing this to enable the use of the StreamingCrud interface...
    return this;
  }
}