
import 'package:flutter/material.dart';

const Color _lightGreen = Color(0xFFE2FFCC);

class StickerWithText {
  final Sticker sticker;
  final String? text;

  StickerWithText(this.sticker, this.text);
}

enum Sticker {
  red,
  green,
  greenBaby,
  yellow,
  yellowBaby,
  white,
  whiteBaby;

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
    }
  }

  bool get showBaby {
    switch (this) {
      case Sticker.red:
      case Sticker.green:
      case Sticker.yellow:
      case Sticker.white:
        return false;
      case Sticker.greenBaby:
      case Sticker.yellowBaby:
      case Sticker.whiteBaby:
        return true;
    }
  }
}

