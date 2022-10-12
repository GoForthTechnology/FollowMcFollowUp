
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stickers.g.dart';

const Color _lightGreen = Color(0xFFE2FFCC);

@JsonSerializable(explicitToJson: true)
class StickerWithText {
  final Sticker sticker;
  final String? text;

  StickerWithText(this.sticker, this.text);

  factory StickerWithText.fromJson(Map<String, dynamic> json) => _$StickerWithTextFromJson(json);
  Map<String, dynamic> toJson() => _$StickerWithTextToJson(this);
}

enum Sticker {
  red,
  green,
  greenBaby,
  yellow,
  yellowBaby,
  white,
  whiteBaby,
  grey;

  Color get color {
    switch (this) {
      case Sticker.red:
        return Colors.red;
      case Sticker.green:
        return Colors.green;
      case Sticker.greenBaby:
        return _lightGreen;
      case Sticker.yellow:
      case Sticker.yellowBaby:
        return Colors.yellow;
      case Sticker.whiteBaby:
      case Sticker.white:
        return Colors.white;
      case Sticker.grey:
        return Colors.grey[300]!;
    }
  }

  bool get showBaby {
    switch (this) {
      case Sticker.red:
      case Sticker.green:
      case Sticker.yellow:
      case Sticker.white:
      case Sticker.grey:
        return false;
      case Sticker.greenBaby:
      case Sticker.yellowBaby:
      case Sticker.whiteBaby:
        return true;
    }
  }
}

