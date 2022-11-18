// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distributions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NormalDistribution _$NormalDistributionFromJson(Map<String, dynamic> json) =>
    NormalDistribution(
      json['mean'] as int,
      (json['stdDev'] as num).toDouble(),
    );

Map<String, dynamic> _$NormalDistributionToJson(NormalDistribution instance) =>
    <String, dynamic>{
      'mean': instance.mean,
      'stdDev': instance.stdDev,
    };
