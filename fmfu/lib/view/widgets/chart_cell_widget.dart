import 'package:flutter/material.dart';

class ChartCellWidget extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;
  final void Function() onTap;

  const ChartCellWidget({Key? key, required this.content, required this.backgroundColor, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: backgroundColor,
        ),
        child: content,
      ),
    );
  }
}