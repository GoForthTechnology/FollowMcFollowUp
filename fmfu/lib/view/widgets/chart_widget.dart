import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/view/widgets/cycle_widget.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';

class ChartWidget extends StatelessWidget {
  final Cycles cycles;

  const ChartWidget({Key? key, required this.cycles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20), child: Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          child: Column(
            children: [
              _createHeaderRow(),
              ..._createCycleRows(),
            ],
          )),
          _createFooterRow(),
        ],
      )));
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
    for (var cycle in cycles) {
      rows.add(CycleWidget(observations: cycle));
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