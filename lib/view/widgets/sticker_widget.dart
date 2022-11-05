import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';

class StickerWidget extends StatelessWidget {
  final StickerWithText? stickerWithText;
  final void Function() onTap;

  const StickerWidget({Key? key, required this.stickerWithText, required this.onTap}) : super(key: key);

  static const Icon emptyIcon = Icon(null);
  static const Text emptyText = Text("");

  @override
  Widget build(BuildContext context) {
    Widget content = Container();
    Color stickerBackgroundColor = Colors.white;
    if (stickerWithText != null) {
      stickerBackgroundColor = stickerWithText!.sticker.color;
      content =  Stack(
        alignment: Alignment.center,
        children: [
          stickerWithText!.text == "" ? emptyText : Text(
            stickerWithText!.text ?? "", textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          stickerWithText!.sticker.showBaby ? Icon(
            stickerWithText!.sticker.showBaby ? Icons.child_care : null,
            color: Colors.black12,
          ) : emptyIcon,
        ],
      );
    }
    return ChartCellWidget(content: content, backgroundColor: stickerBackgroundColor, onTap: onTap);
  }

}