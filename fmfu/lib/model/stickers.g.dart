// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stickers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StickerWithText _$StickerWithTextFromJson(Map<String, dynamic> json) =>
    StickerWithText(
      $enumDecode(_$StickerEnumMap, json['sticker']),
      json['text'] as String?,
    );

Map<String, dynamic> _$StickerWithTextToJson(StickerWithText instance) =>
    <String, dynamic>{
      'sticker': _$StickerEnumMap[instance.sticker]!,
      'text': instance.text,
    };

const _$StickerEnumMap = {
  Sticker.red: 'red',
  Sticker.green: 'green',
  Sticker.greenBaby: 'greenBaby',
  Sticker.yellow: 'yellow',
  Sticker.yellowBaby: 'yellowBaby',
  Sticker.white: 'white',
  Sticker.whiteBaby: 'whiteBaby',
  Sticker.grey: 'grey',
};
