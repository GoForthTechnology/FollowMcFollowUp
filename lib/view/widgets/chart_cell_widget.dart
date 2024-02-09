import 'package:flutter/material.dart';

class ChartCellWidget extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;
  final void Function() onTap;
  final void Function()? onLongPress;
  final Alignment alignment;

  const ChartCellWidget({
    super.key,
    this.alignment = Alignment.center,
    this.onLongPress,
    required this.content,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 40,
        height: 60,
        alignment: alignment,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: backgroundColor,
        ),
        child: Padding(padding: const EdgeInsets.only(top: 4), child: content),
      ),
    );
  }
}
