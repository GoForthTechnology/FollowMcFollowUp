

import 'package:fmfu/utils/crud_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentProfile extends Indexable<StudentProfile> {

  final String? id;
  final String? programId;
  final String firstName;
  final String lastName;
  final String emailAddress;

  StudentProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    this.programId,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) => _$StudentProfileFromJson(json);
  Map<String, dynamic> toJson() => _$StudentProfileToJson(this);

  String fullName() {
    return "$firstName $lastName";
  }

  @override
  String? getId() {
    return id;
  }

  @override
  StudentProfile setId(String id) {
    return StudentProfile(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, programId: programId);
  }

  StudentProfile enrollStudent(String? programId) {
    return StudentProfile(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, programId: programId);
  }
}