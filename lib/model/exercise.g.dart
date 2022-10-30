// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseState _$ExerciseStateFromJson(Map<String, dynamic> json) =>
    ExerciseState(
      (json['activeInstructions'] as List<dynamic>)
          .map((e) => $enumDecode(_$InstructionEnumMap, e))
          .toList(),
      (json['errorScenarios'] as List<dynamic>)
          .map((e) => $enumDecode(_$ErrorScenarioEnumMap, e))
          .toList(),
      (json['cycles'] as List<dynamic>)
          .map((e) => Cycle.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['followUps'] as List<dynamic>)
          .map((e) => const LocalDateJsonConverter().fromJson(e as int))
          .toList(),
      const LocalDateJsonConverter().fromJson(json['startOfCharting'] as int),
    );

Map<String, dynamic> _$ExerciseStateToJson(ExerciseState instance) =>
    <String, dynamic>{
      'activeInstructions': instance.activeInstructions
          .map((e) => _$InstructionEnumMap[e]!)
          .toList(),
      'errorScenarios': instance.errorScenarios
          .map((e) => _$ErrorScenarioEnumMap[e]!)
          .toList(),
      'cycles': instance.cycles.map((e) => e.toJson()).toList(),
      'followUps': instance.followUps
          .map(const LocalDateJsonConverter().toJson)
          .toList(),
      'startOfCharting':
          const LocalDateJsonConverter().toJson(instance.startOfCharting),
    };

const _$InstructionEnumMap = {
  Instruction.a: 'a',
  Instruction.b: 'b',
  Instruction.c: 'c',
  Instruction.d1: 'd1',
  Instruction.d2: 'd2',
  Instruction.d3: 'd3',
  Instruction.d4: 'd4',
  Instruction.d5: 'd5',
  Instruction.d6: 'd6',
  Instruction.e1: 'e1',
  Instruction.e2: 'e2',
  Instruction.e3: 'e3',
  Instruction.e4: 'e4',
  Instruction.e5: 'e5',
  Instruction.e6: 'e6',
  Instruction.e7: 'e7',
  Instruction.f: 'f',
  Instruction.g1: 'g1',
  Instruction.g2: 'g2',
  Instruction.g3: 'g3',
  Instruction.h: 'h',
  Instruction.i1: 'i1',
  Instruction.i2: 'i2',
  Instruction.i3: 'i3',
  Instruction.i4: 'i4',
  Instruction.j: 'j',
  Instruction.k1: 'k1',
  Instruction.k2: 'k2',
  Instruction.k3: 'k3',
  Instruction.k4: 'k4',
  Instruction.k5: 'k5',
  Instruction.k6: 'k6',
  Instruction.l: 'l',
  Instruction.m: 'm',
  Instruction.n: 'n',
  Instruction.o: 'o',
  Instruction.ys1c: 'ys1c',
};

const _$ErrorScenarioEnumMap = {
  ErrorScenario.forgetD4: 'forgetD4',
  ErrorScenario.forgetObservationOnFlow: 'forgetObservationOnFlow',
};
