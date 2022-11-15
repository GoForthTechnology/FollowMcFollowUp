// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cycle _$CycleFromJson(Map<String, dynamic> json) => Cycle(
      index: json['index'] as int,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => ChartEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      stickerCorrections:
          (json['stickerCorrections'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), StickerWithText.fromJson(e as Map<String, dynamic>)),
      ),
      observationCorrections:
          (json['observationCorrections'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      cycleStats: json['cycleStats'] == null
          ? CycleStats.empty
          : CycleStats.fromJson(json['cycleStats'] as Map<String, dynamic>),
    )..canRerender = json['canRerender'] as bool;

Map<String, dynamic> _$CycleToJson(Cycle instance) => <String, dynamic>{
      'index': instance.index,
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'stickerCorrections': instance.stickerCorrections
          .map((k, e) => MapEntry(k.toString(), e.toJson())),
      'observationCorrections': instance.observationCorrections
          .map((k, e) => MapEntry(k.toString(), e)),
      'canRerender': instance.canRerender,
      'cycleStats': instance.cycleStats.toJson(),
    };

CycleStats _$CycleStatsFromJson(Map<String, dynamic> json) => CycleStats(
      mucusCycleScore: (json['mucusCycleScore'] as num?)?.toDouble(),
      lengthOfPostPeakPhase: json['lengthOfPostPeakPhase'] as int?,
    );

Map<String, dynamic> _$CycleStatsToJson(CycleStats instance) =>
    <String, dynamic>{
      'mucusCycleScore': instance.mucusCycleScore,
      'lengthOfPostPeakPhase': instance.lengthOfPostPeakPhase,
    };

ChartEntry _$ChartEntryFromJson(Map<String, dynamic> json) => ChartEntry(
      observationText: json['observationText'] as String,
      renderedObservation: json['renderedObservation'] == null
          ? null
          : RenderedObservation.fromJson(
              json['renderedObservation'] as Map<String, dynamic>),
      manualSticker: json['manualSticker'] == null
          ? null
          : StickerWithText.fromJson(
              json['manualSticker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartEntryToJson(ChartEntry instance) =>
    <String, dynamic>{
      'observationText': instance.observationText,
      'renderedObservation': instance.renderedObservation?.toJson(),
      'manualSticker': instance.manualSticker?.toJson(),
    };
