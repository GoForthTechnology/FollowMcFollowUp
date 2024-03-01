import 'package:flutter/material.dart';

class ChartRowWidget extends StatelessWidget {
  static int nSectionsPerRow = 5;
  static int nEntriesPerSection = 7;

  final int dayOffset;
  final Widget Function(int) topCellCreator;
  final Widget Function(int) bottomCellCreator;
  final Widget? rightWidget;

  const ChartRowWidget({super.key, required this.dayOffset, required this.topCellCreator, required this.bottomCellCreator, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [];
    for (int i=0; i<nSectionsPerRow; i++) {
      sections.add(_createSection(context, i));
    }
    if (rightWidget != null) {
      sections.add(rightWidget!);
    }
    return Row(children: sections);
  }

  Widget _createSection(BuildContext context, int sectionIndex) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: _createEntries(context, sectionIndex),
      ),
    );
  }

  List<Widget> _createEntries(BuildContext context, int sectionIndex) {
    List<Widget> stackedCells = [];
    for (int i = 0; i < nEntriesPerSection; i++) {
      int entryIndex = sectionIndex * nEntriesPerSection + i + dayOffset;
      stackedCells.add(Column(children: [
        topCellCreator(entryIndex), bottomCellCreator(entryIndex)]));
    }
    return stackedCells;
  }
}
