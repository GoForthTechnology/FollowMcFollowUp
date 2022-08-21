
import 'dart:math';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/control_bar_widget.dart';
import 'package:fmfu/view/widgets/cycle_widget.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/view_model/cycle_view_model.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartPageState();
}

typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _ChartPageState extends State<ChartPage> {
  Corrections corrections = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Grid Page"),
      ),
      // TODO: figure out how to make horizontal scrolling work...
      body: Consumer<CycleViewModel>(
        builder: (context, model, child) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              const ControlBarWidget(),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    itemCount: model.cycles.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _createHeaderRow();
                      }
                      return CycleWidget(observations: model.cycles[index-1]);
                    },
                  ),
              )),
            ],
          ),
        ),
      )
    );
  }
}

const int nSectionsPerCycle = 5;
const int nEntriesPerSection = 7;

Widget _createHeaderRow() {
  List<Widget> sections = [];
  for (int i=0; i<nSectionsPerCycle; i++) {
    List<Widget> entries = [];
    for (int j=0; j<nEntriesPerSection; j++) {
      int entryNum = i*nEntriesPerSection + j + 1;
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
