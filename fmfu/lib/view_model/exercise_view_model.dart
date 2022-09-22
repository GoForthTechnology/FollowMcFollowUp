import 'package:flutter/material.dart';

class ExerciseViewModel extends ChangeNotifier {
  final List<Student> _students = [];

  List<Student> students() {
    return _students;
  }

  void addStudent(Student student) {
    _students.add(student);
  }

}

class Student {
  final int id;
  final String firstName;
  final String lastName;

  Student(this.id, this.firstName, this.lastName);
}
