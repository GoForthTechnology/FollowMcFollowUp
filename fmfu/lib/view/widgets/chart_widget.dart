import 'package:flutter/material.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/view/widgets/cycle_widget.dart';

class ChartWidget extends StatelessWidget {
  final Chart chart;
  final Widget? titleWidget;

  const ChartWidget({Key? key, required this.chart, this.titleWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20), child: Container(
      child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget ?? Container(),
          _createHeaderRow(),
          ..._createCycleRows(),
          _createFooterRow(),
        ],
      ))));
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
      rows.add(CycleWidget(cycle: slice.cycle, dayOffset: slice.offset));
    }
    return rows;
  }

  Widget _createFooterRow() {
    return const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Use these signs: P = Peak, 123 = Fertile days following Peak, I = Intercourse"),
    );
  }
}