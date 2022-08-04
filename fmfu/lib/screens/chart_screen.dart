
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Grid Page"),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(children: _createRows(context))
      ),
    );
  }
}

const int nCycleRows = 4;
const int nSectionsPerCycle = 5;
const int nEntriesPerSection = 7;

List<Widget> _createRows(BuildContext context) {
  List<Widget> rows = [_createHeaderRow()];
  for (int i=0; i < nCycleRows; i++) {
    rows.add(_createCycleRow(i, context));
  }
  return rows;
}

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

Widget _createCycleRow(int rowIndex, BuildContext context) {
  List<Widget> sections = [];
  for (int i=0; i<nSectionsPerCycle; i++) {
    sections.add(_createSection(rowIndex, i, context));
  }
  return Row(children: sections);
}

Widget _createSection(int rowIndex, int sectionIndex, BuildContext context) {
  return
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: <Widget>[
          _stickerSubsection(rowIndex, sectionIndex, context),
          _entrySubsection(rowIndex, sectionIndex, context),
        ],
      ),
    );
}

Widget _stickerSubsection(int rowIndex, int sectionIndex, BuildContext context) {
  List<Widget> cells = [];
  for (int i=0; i<nEntriesPerSection; i++) {
    cells.add(_createCell(Container(), (){
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(content: Text('Sticker click: cycle #${rowIndex+1}')),
      );
    }));
  }
  return Row(children: cells);
}

Widget _entrySubsection(int rowIndex, int sectionIndex, BuildContext context) {
  List<Widget> cells = [];
  for (int i=0; i<nEntriesPerSection; i++) {
    int cycleNum = rowIndex + 1;
    int entryNum = sectionIndex * nEntriesPerSection + i + 1;
    cells.add(_createCell(Text("($cycleNum, $entryNum)"), () {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(content: Text('Entry click: cycle #${rowIndex+1}')),
      );
    }));
  }
  return Row(children: cells);
}

Widget _createCell(Widget content, void Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: content,
    ),
  );
}
