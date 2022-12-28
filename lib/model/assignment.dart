
import 'package:fmfu/model/exercise.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assignment.g.dart';

@JsonSerializable(explicitToJson: true)
class Assignment {
  final AssignmentIdentifier identifier;
  final PreClientAssignment? preClientAssignment;

  Assignment({required this.identifier, this.preClientAssignment});

  factory Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AssignmentIdentifier {
  final AssignmentType type;
  final String? id;

  AssignmentIdentifier(this.type, this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentIdentifier &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          id == other.id;

  @override
  int get hashCode => type.hashCode ^ id.hashCode;

  factory AssignmentIdentifier.fromJson(Map<String, dynamic> json) => _$AssignmentIdentifierFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentIdentifierToJson(this);
}

enum AssignmentType {
  preClient,
  identifyingChartingPatterns,
  caseManagementSimulation,
  ;

  String get description {
    switch (this) {
      case AssignmentType.preClient:
        return "Pre-Client";
      case AssignmentType.identifyingChartingPatterns:
        return "Identifying Charting Patterns (Section 10)";
      case AssignmentType.caseManagementSimulation:
        return "Case Management Simulation (Section 10)";
    }
  }
}

@JsonSerializable(explicitToJson: true)
class CaseManagementSimulation {
  final String description;
  final ExerciseState chartState;

  CaseManagementSimulation(this.description, this.chartState);

  factory CaseManagementSimulation.fromJson(Map<String, dynamic> json) => _$CaseManagementSimulationFromJson(json);
  Map<String, dynamic> toJson() => _$CaseManagementSimulationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PreClientAssignment {
  final int num;
  final String instructions;
  final List<Question> questions;

  const PreClientAssignment(this.num, this.instructions, this.questions);

  bool get enabled => questions.isNotEmpty;

  factory PreClientAssignment.fromJson(Map<String, dynamic> json) => _$PreClientAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$PreClientAssignmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Question {
  final int number;
  final String question;
  final MultipleChoice? multipleChoice;

  const Question({required this.number, required this.question, this.multipleChoice});

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MultipleChoice {

  final Map<String, String> options;

  const MultipleChoice(this.options);

  factory MultipleChoice.fromJson(Map<String, dynamic> json) => _$MultipleChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$MultipleChoiceToJson(this);
}