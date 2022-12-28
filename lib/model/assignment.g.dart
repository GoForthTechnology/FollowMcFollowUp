// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assignment _$AssignmentFromJson(Map<String, dynamic> json) => Assignment(
      identifier: AssignmentIdentifier.fromJson(
          json['identifier'] as Map<String, dynamic>),
      preClientAssignment: json['preClientAssignment'] == null
          ? null
          : PreClientAssignment.fromJson(
              json['preClientAssignment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssignmentToJson(Assignment instance) =>
    <String, dynamic>{
      'identifier': instance.identifier.toJson(),
      'preClientAssignment': instance.preClientAssignment?.toJson(),
    };

AssignmentIdentifier _$AssignmentIdentifierFromJson(
        Map<String, dynamic> json) =>
    AssignmentIdentifier(
      type: $enumDecode(_$AssignmentTypeEnumMap, json['type']),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$AssignmentIdentifierToJson(
        AssignmentIdentifier instance) =>
    <String, dynamic>{
      'type': _$AssignmentTypeEnumMap[instance.type]!,
      'id': instance.id,
    };

const _$AssignmentTypeEnumMap = {
  AssignmentType.preClient: 'preClient',
  AssignmentType.identifyingChartingPatterns: 'identifyingChartingPatterns',
  AssignmentType.caseManagementSimulation: 'caseManagementSimulation',
};

CaseManagementSimulation _$CaseManagementSimulationFromJson(
        Map<String, dynamic> json) =>
    CaseManagementSimulation(
      json['description'] as String,
      ExerciseState.fromJson(json['chartState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CaseManagementSimulationToJson(
        CaseManagementSimulation instance) =>
    <String, dynamic>{
      'description': instance.description,
      'chartState': instance.chartState.toJson(),
    };

PreClientAssignment _$PreClientAssignmentFromJson(Map<String, dynamic> json) =>
    PreClientAssignment(
      json['num'] as int,
      json['instructions'] as String,
      (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreClientAssignmentToJson(
        PreClientAssignment instance) =>
    <String, dynamic>{
      'num': instance.num,
      'instructions': instance.instructions,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      number: json['number'] as int,
      question: json['question'] as String,
      multipleChoice: json['multipleChoice'] == null
          ? null
          : MultipleChoice.fromJson(
              json['multipleChoice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'number': instance.number,
      'question': instance.question,
      'multipleChoice': instance.multipleChoice?.toJson(),
    };

MultipleChoice _$MultipleChoiceFromJson(Map<String, dynamic> json) =>
    MultipleChoice(
      Map<String, String>.from(json['options'] as Map),
    );

Map<String, dynamic> _$MultipleChoiceToJson(MultipleChoice instance) =>
    <String, dynamic>{
      'options': instance.options,
    };
