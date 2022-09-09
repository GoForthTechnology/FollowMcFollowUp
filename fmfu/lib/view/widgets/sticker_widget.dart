import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';

class StickerWidget extends StatelessWidget {
  final StickerWithText? stickerWithText;
  final void Function() onTap;

  const StickerWidget({Key? key, required this.stickerWithText, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container();
    Color stickerBackgroundColor = Colors.white;
    if (stickerWithText != null) {
      stickerBackgroundColor = stickerWithText!.sticker.color;
      content =  Stack(
        alignment: Alignment.center,
        children: [
          Text(
            stickerWithText!.text ?? "", textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Icon(
            stickerWithText!.sticker.showBaby ? Icons.child_care : null,
            color: Colors.black12,
          )
        ],
      );
    }
    return ChartCellWidget(content: content, backgroundColor: stickerBackgroundColor, onTap: onTap);
  }

}