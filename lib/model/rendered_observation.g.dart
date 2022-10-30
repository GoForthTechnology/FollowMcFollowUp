// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendered_observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenderedObservation _$RenderedObservationFromJson(Map<String, dynamic> json) =>
    RenderedObservation(
      json['observationText'] as String,
      json['countOfThree'] as int,
      json['isPeakDay'] as bool,
      json['hasBleeding'] as bool,
      json['hasMucus'] as bool,
      json['inFlow'] as bool,
      (json['fertilityReasons'] as List<dynamic>)
          .map((e) => $enumDecode(_$InstructionEnumMap, e))
          .toList(),
      (json['infertilityReasons'] as List<dynamic>)
          .map((e) => $enumDecode(_$InstructionEnumMap, e))
          .toList(),
      json['essentiallyTheSame'] as bool?,
      DebugInfo.fromJson(json['debugInfo'] as Map<String, dynamic>),
      _$JsonConverterFromJson<int, LocalDate>(
          json['date'], const LocalDateJsonConverter().fromJson),
    );

Map<String, dynamic> _$RenderedObservationToJson(
        RenderedObservation instance) =>
    <String, dynamic>{
      'observationText': instance.observationText,
      'countOfThree': instance.countOfThree,
      'isPeakDay': instance.isPeakDay,
      'hasBleeding': instance.hasBleeding,
      'hasMucus': instance.hasMucus,
      'inFlow': instance.inFlow,
      'essentiallyTheSame': instance.essentiallyTheSame,
      'fertilityReasons': instance.fertilityReasons
          .map((e) => _$InstructionEnumMap[e]!)
          .toList(),
      'infertilityReasons': instance.infertilityReasons
          .map((e) => _$InstructionEnumMap[e]!)
          .toList(),
      'debugInfo': instance.debugInfo.toJson(),
      'date': _$JsonConverterToJson<int, LocalDate>(
          instance.date, const LocalDateJsonConverter().toJson),
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

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

DebugInfo _$DebugInfoFromJson(Map<String, dynamic> json) => DebugInfo(
      countOfThreeReason: $enumDecodeNullable(
          _$CountOfThreeReasonEnumMap, json['countOfThreeReason']),
    );

Map<String, dynamic> _$DebugInfoToJson(DebugInfo instance) => <String, dynamic>{
      'countOfThreeReason':
          _$CountOfThreeReasonEnumMap[instance.countOfThreeReason],
    };

const _$CountOfThreeReasonEnumMap = {
  CountOfThreeReason.unusualBleeding: 'unusualBleeding',
  CountOfThreeReason.peakDay: 'peakDay',
  CountOfThreeReason.consecutiveDaysOfNonPeakMucus:
      'consecutiveDaysOfNonPeakMucus',
  CountOfThreeReason.singleDayOfPeakMucus: 'singleDayOfPeakMucus',
  CountOfThreeReason.pointOfChange: 'pointOfChange',
  CountOfThreeReason.uncertain: 'uncertain',
};
