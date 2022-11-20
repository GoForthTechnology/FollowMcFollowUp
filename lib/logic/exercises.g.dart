// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseObservation _$ExerciseObservationFromJson(Map<String, dynamic> json) =>
    ExerciseObservation(
      json['observationText'] as String,
      json['stamp'] == null
          ? null
          : StickerWithText.fromJson(json['stamp'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExerciseObservationToJson(
        ExerciseObservation instance) =>
    <String, dynamic>{
      'stamp': instance.stamp?.toJson(),
      'observationText': instance.observationText,
    };

StaticExercise _$StaticExerciseFromJson(Map<String, dynamic> json) =>
    StaticExercise(
      json['name'] as String,
      (json['cycles'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) =>
                  ExerciseObservation.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$StaticExerciseToJson(StaticExercise instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cycles': instance.cycles
          .map((e) => e.map((e) => e.toJson()).toList())
          .toList(),
    };

DynamicExercise _$DynamicExerciseFromJson(Map<String, dynamic> json) =>
    DynamicExercise(
      recipe: json['recipe'] == null
          ? null
          : CycleRecipe.fromJson(json['recipe'] as Map<String, dynamic>),
      errorScenarios: (json['errorScenarios'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$ErrorScenarioEnumMap, k), (e as num).toDouble()),
          ) ??
          const {},
      name: json['name'],
    );

Map<String, dynamic> _$DynamicExerciseToJson(DynamicExercise instance) =>
    <String, dynamic>{
      'name': instance.name,
      'recipe': instance.recipe?.toJson(),
      'errorScenarios': instance.errorScenarios
          .map((k, e) => MapEntry(_$ErrorScenarioEnumMap[k]!, e)),
    };

const _$ErrorScenarioEnumMap = {
  ErrorScenario.forgetD4: 'forgetD4',
  ErrorScenario.forgetObservationOnFlow: 'forgetObservationOnFlow',
  ErrorScenario.forgetRedStampForUnusualBleeding:
      'forgetRedStampForUnusualBleeding',
  ErrorScenario.forgetCountOfThreeForUnusualBleeding:
      'forgetCountOfThreeForUnusualBleeding',
};
