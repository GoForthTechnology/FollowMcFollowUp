// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_generation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleRecipe _$CycleRecipeFromJson(Map<String, dynamic> json) => CycleRecipe(
      FlowRecipe.fromJson(json['flowRecipe'] as Map<String, dynamic>),
      PreBuildUpRecipe.fromJson(
          json['preBuildUpRecipe'] as Map<String, dynamic>),
      BuildUpRecipe.fromJson(json['buildUpRecipe'] as Map<String, dynamic>),
      PostPeakRecipe.fromJson(json['postPeakRecipe'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CycleRecipeToJson(CycleRecipe instance) =>
    <String, dynamic>{
      'flowRecipe': instance.flowRecipe.toJson(),
      'preBuildUpRecipe': instance.preBuildUpRecipe.toJson(),
      'buildUpRecipe': instance.buildUpRecipe.toJson(),
      'postPeakRecipe': instance.postPeakRecipe.toJson(),
    };

FlowRecipe _$FlowRecipeFromJson(Map<String, dynamic> json) => FlowRecipe(
      NormalDistribution.fromJson(json['flowLength'] as Map<String, dynamic>),
      $enumDecode(_$FlowEnumMap, json['maxFlow']),
      $enumDecode(_$FlowEnumMap, json['minFlow']),
      DischargeSummaryGenerator.fromJson(
          json['dischargeSummaryGenerator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FlowRecipeToJson(FlowRecipe instance) =>
    <String, dynamic>{
      'maxFlow': _$FlowEnumMap[instance.maxFlow]!,
      'minFlow': _$FlowEnumMap[instance.minFlow]!,
      'flowLength': instance.flowLength.toJson(),
      'dischargeSummaryGenerator': instance.dischargeSummaryGenerator.toJson(),
    };

const _$FlowEnumMap = {
  Flow.heavy: 'heavy',
  Flow.medium: 'medium',
  Flow.light: 'light',
  Flow.veryLight: 'veryLight',
};

PreBuildUpRecipe _$PreBuildUpRecipeFromJson(Map<String, dynamic> json) =>
    PreBuildUpRecipe(
      NormalDistribution.fromJson(json['length'] as Map<String, dynamic>),
      DischargeSummaryGenerator.fromJson(
          json['nonMucusDischargeGenerator'] as Map<String, dynamic>),
      NormalAnomalyGenerator.fromJson(
          json['abnormalBleedingGenerator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreBuildUpRecipeToJson(PreBuildUpRecipe instance) =>
    <String, dynamic>{
      'length': instance.length.toJson(),
      'nonMucusDischargeGenerator':
          instance.nonMucusDischargeGenerator.toJson(),
      'abnormalBleedingGenerator': instance.abnormalBleedingGenerator.toJson(),
    };

BuildUpRecipe _$BuildUpRecipeFromJson(Map<String, dynamic> json) =>
    BuildUpRecipe(
      NormalDistribution.fromJson(json['lengthDist'] as Map<String, dynamic>),
      NormalDistribution.fromJson(
          json['peakTypeLengthDist'] as Map<String, dynamic>),
      DischargeSummaryGenerator.fromJson(
          json['peakTypeDischargeGenerator'] as Map<String, dynamic>),
      DischargeSummaryGenerator.fromJson(
          json['nonPeakTypeDischargeGenerator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BuildUpRecipeToJson(BuildUpRecipe instance) =>
    <String, dynamic>{
      'lengthDist': instance.lengthDist.toJson(),
      'peakTypeLengthDist': instance.peakTypeLengthDist.toJson(),
      'peakTypeDischargeGenerator':
          instance.peakTypeDischargeGenerator.toJson(),
      'nonPeakTypeDischargeGenerator':
          instance.nonPeakTypeDischargeGenerator.toJson(),
    };

PostPeakRecipe _$PostPeakRecipeFromJson(Map<String, dynamic> json) =>
    PostPeakRecipe(
      lengthDist: NormalDistribution.fromJson(
          json['lengthDist'] as Map<String, dynamic>),
      mucusLengthDist: NormalDistribution.fromJson(
          json['mucusLengthDist'] as Map<String, dynamic>),
      mucusDischargeGenerator: DischargeSummaryGenerator.fromJson(
          json['mucusDischargeGenerator'] as Map<String, dynamic>),
      nonMucusDischargeGenerator: DischargeSummaryGenerator.fromJson(
          json['nonMucusDischargeGenerator'] as Map<String, dynamic>),
      abnormalBleedingGenerator: NormalAnomalyGenerator.fromJson(
          json['abnormalBleedingGenerator'] as Map<String, dynamic>),
      preMenstrualSpottingLengthDist: NormalDistribution.fromJson(
          json['preMenstrualSpottingLengthDist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostPeakRecipeToJson(PostPeakRecipe instance) =>
    <String, dynamic>{
      'lengthDist': instance.lengthDist.toJson(),
      'mucusLengthDist': instance.mucusLengthDist.toJson(),
      'mucusDischargeGenerator': instance.mucusDischargeGenerator.toJson(),
      'nonMucusDischargeGenerator':
          instance.nonMucusDischargeGenerator.toJson(),
      'abnormalBleedingGenerator': instance.abnormalBleedingGenerator.toJson(),
      'preMenstrualSpottingLengthDist':
          instance.preMenstrualSpottingLengthDist.toJson(),
    };

NormalAnomalyGenerator _$NormalAnomalyGeneratorFromJson(
        Map<String, dynamic> json) =>
    NormalAnomalyGenerator(
      lengthDist: NormalDistribution.fromJson(
          json['lengthDist'] as Map<String, dynamic>),
      probability: (json['probability'] as num).toDouble(),
    );

Map<String, dynamic> _$NormalAnomalyGeneratorToJson(
        NormalAnomalyGenerator instance) =>
    <String, dynamic>{
      'lengthDist': instance.lengthDist.toJson(),
      'probability': instance.probability,
    };

DischargeRecipe _$DischargeRecipeFromJson(Map<String, dynamic> json) =>
    DischargeRecipe(
      dischargeType: $enumDecode(_$DischargeTypeEnumMap, json['dischargeType']),
      dischargeFrequencies: (json['dischargeFrequencies'] as List<dynamic>)
          .map((e) => $enumDecode(_$DischargeFrequencyEnumMap, e))
          .toSet(),
      dischargeDescriptors: (json['dischargeDescriptors'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DischargeDescriptorEnumMap, e))
              .toSet() ??
          const {},
    );

Map<String, dynamic> _$DischargeRecipeToJson(DischargeRecipe instance) =>
    <String, dynamic>{
      'dischargeType': _$DischargeTypeEnumMap[instance.dischargeType]!,
      'dischargeDescriptors': instance.dischargeDescriptors
          .map((e) => _$DischargeDescriptorEnumMap[e]!)
          .toList(),
      'dischargeFrequencies': instance.dischargeFrequencies
          .map((e) => _$DischargeFrequencyEnumMap[e]!)
          .toList(),
    };

const _$DischargeTypeEnumMap = {
  DischargeType.dry: 'dry',
  DischargeType.wetWithoutLubrication: 'wetWithoutLubrication',
  DischargeType.dampWithoutLubrication: 'dampWithoutLubrication',
  DischargeType.shinyWithoutLubrication: 'shinyWithoutLubrication',
  DischargeType.sticky: 'sticky',
  DischargeType.tacky: 'tacky',
  DischargeType.wetWithLubrication: 'wetWithLubrication',
  DischargeType.dampWithLubrication: 'dampWithLubrication',
  DischargeType.shinyWithLubrication: 'shinyWithLubrication',
  DischargeType.stretchy: 'stretchy',
};

const _$DischargeFrequencyEnumMap = {
  DischargeFrequency.once: 'once',
  DischargeFrequency.twice: 'twice',
  DischargeFrequency.thrice: 'thrice',
  DischargeFrequency.allDay: 'allDay',
};

const _$DischargeDescriptorEnumMap = {
  DischargeDescriptor.brown: 'brown',
  DischargeDescriptor.red: 'red',
  DischargeDescriptor.cloudyClear: 'cloudyClear',
  DischargeDescriptor.cloudy: 'cloudy',
  DischargeDescriptor.gummy: 'gummy',
  DischargeDescriptor.clear: 'clear',
  DischargeDescriptor.lubricative: 'lubricative',
  DischargeDescriptor.pasty: 'pasty',
  DischargeDescriptor.yellow: 'yellow',
};

DischargeSummaryGenerator _$DischargeSummaryGeneratorFromJson(
        Map<String, dynamic> json) =>
    DischargeSummaryGenerator(
      DischargeRecipe.fromJson(
          json['typicalDischarge'] as Map<String, dynamic>),
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((e) => AlternativeDischargeSummaryGenerator.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DischargeSummaryGeneratorToJson(
        DischargeSummaryGenerator instance) =>
    <String, dynamic>{
      'typicalDischarge': instance.typicalDischarge.toJson(),
      'alternatives': instance.alternatives.map((e) => e.toJson()).toList(),
    };

AlternativeDischargeSummaryGenerator
    _$AlternativeDischargeSummaryGeneratorFromJson(Map<String, dynamic> json) =>
        AlternativeDischargeSummaryGenerator(
          DischargeSummaryGenerator.fromJson(
              json['generator'] as Map<String, dynamic>),
          probability: (json['probability'] as num).toDouble(),
        );

Map<String, dynamic> _$AlternativeDischargeSummaryGeneratorToJson(
        AlternativeDischargeSummaryGenerator instance) =>
    <String, dynamic>{
      'generator': instance.generator.toJson(),
      'probability': instance.probability,
    };
