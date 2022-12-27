

import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentProfile extends Indexable<StudentProfile> {

  final String id;
  final String firstName;
  final String lastName;
  final String emailAddress;

  StudentProfile({required this.id, required this.firstName, required this.lastName, required this.emailAddress});

  factory StudentProfile.fromJson(Map<String, dynamic> json) => _$StudentProfileFromJson(json);
  Map<String, dynamic> toJson() => _$StudentProfileToJson(this);

  @override
  String? getId() {
    return id;
  }

  @override
  StudentProfile setId(String id) {
    // This is a hack and an abuse of the Indexable interface.
    // Doing this to enable the use of the StreamingCrud interface...
    return this;
  }
}