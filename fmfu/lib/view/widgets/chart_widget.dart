import 'package:flutter/material.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/view/widgets/cycle_widget.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:loggy/loggy.dart';

class ChartWidget extends StatelessWidget with UiLoggy {
  final Chart chart;
  final ChartViewModel model;
  final Widget? titleWidget;
  final bool editingEnabled;
  final bool correctingEnabled;
  final bool showErrors;
  final bool showStats;
  final SoloCell? soloCell;
  final bool includeFooter;

  const ChartWidget({
    required this.chart,
    required this.model,
    this.editingEnabled = false,
    this.correctingEnabled = false,
    this.showErrors = false,
    this.showStats = false,
    this.includeFooter = true,
    this.titleWidget,
    this.soloCell,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget ?? Container(),
          _createHeaderRow(),
          ..._createCycleRows(),
          if (includeFooter) _createFooterRow(),
        ],
      ));
  }

  Widget _createHeaderRow() {
    List<Widget> sections = [];
    for (int i=0; i<CycleWidget.nSectionsPerCycle; i++) {
      List<Widget> entries = [];
      for (int j=0; j<CycleWidget.nEntriesPerSection; j++) {
        int entryNum = i*CycleWidget.nEntriesPerSection + j + 1;
        entries.add(Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          height: 40,
          width: 40,
          child: Text("$entryNum"),
        ));
      }
      sections.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(children: entries),
      ));
    }
    return Row(
      children: sections,
    );
  }

  List<Widget> _createCycleRows() {
    List<Widget> rows = [];
    for (var slice in chart.cycles) {
      rows.add(CycleWidget(
        cycle: slice.cycle,
        model: model,
        editingEnabled: editingEnabled,
        correctingEnabled: correctingEnabled,
        showErrors: showErrors,
        dayOffset: slice.offset,
        showStats: showStats,
        soloCell: soloCell,
      ));
    }
    loggy.debug("Created ${rows.length} rows");
    return rows;
  }

  Widget _createFooterRow() {
    return const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Use these signs: P = Peak, 123 = Fertile days following Peak, I = Intercourse"),
    );
  }
}

class SoloCell {
  final int cycleIndex;
  final int entryIndex;
  final bool showSticker;

  SoloCell({
    required this.cycleIndex,
    required this.entryIndex,
    required this.showSticker,
  });
}
