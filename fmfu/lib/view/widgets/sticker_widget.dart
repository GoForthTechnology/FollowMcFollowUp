import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';

class StickerWidget extends StatelessWidget {
  final Sticker? sticker;
  final String? stickerText;
  final void Function() onTap;

  const StickerWidget({Key? key, required this.sticker, this.stickerText, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container();
    Color stickerBackgroundColor = Colors.white;
    if (sticker != null) {
      stickerBackgroundColor = sticker!.color;
      content =  Stack(
        alignment: Alignment.center,
        children: [
          Text(
            stickerText ?? "", textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Icon(
            sticker!.showBaby ? Icons.child_care : null,
            color: Colors.black12,
          )
        ],
      );
    }
    return ChartCellWidget(content: content, backgroundColor: stickerBackgroundColor, onTap: onTap);
  }

}