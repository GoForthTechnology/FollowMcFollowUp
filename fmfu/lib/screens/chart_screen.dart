
import 'package:flutter/material.dart';
import 'package:fmfu/models/observation.dart';
import 'package:fmfu/utils/cycle_recipe.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  static List<List<Observation>> cycles = [
    CycleRecipe.standardRecipe.getObservations(),
    CycleRecipe.standardRecipe.getObservations(),
    CycleRecipe.standardRecipe.getObservations(),
    CycleRecipe.standardRecipe.getObservations(),
  ];

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

  static const int nSectionsPerCycle = 5;
  static const int nEntriesPerSection = 7;

  List<Widget> _createRows(BuildContext context) {
    List<Widget> rows = [_createHeaderRow()];
    for (int i=0; i < cycles.length; i++) {
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
        child: Row(
          children: _entries(rowIndex, sectionIndex, context),
        ),
      );
  }

  List<Widget> _entries(int rowIndex, int sectionIndex, BuildContext context) {
    List<Widget> stackedCells = [];
    for (int i=0; i<nEntriesPerSection; i++) {
      List<Observation> observations = cycles[rowIndex];
      int observationIndex = sectionIndex * nEntriesPerSection + i;
      Observation? observation;
      if (observationIndex < observations.length) {
        observation = observations[observationIndex];
      }
      Widget sticker = Container();
      Color stickerBackgroundColor = Colors.white;
      if (observation != null) {
        stickerBackgroundColor = observation.getStickerColor();
        sticker = Icon(
          observation.getIcon(),
          color: Colors.black12,
        );
      }
      stackedCells.add(Column(
        children: [
          _createCell(sticker, stickerBackgroundColor, (){
            final scaffold = ScaffoldMessenger.of(context);
            scaffold.showSnackBar(
              SnackBar(content: Text('Sticker click: cycle #${rowIndex+1}')),
            );
          }),
          _createCell(Text(observation == null ? "" : observation.toString()), Colors.white, () {
            final scaffold = ScaffoldMessenger.of(context);
            scaffold.showSnackBar(
              SnackBar(content: Text('Entry click: cycle #${rowIndex+1}')),
            );
          })
        ],
      ));
    }
    return stackedCells;
  }

  Widget _createCell(Widget content, Color backgroundColor, void Function() onTap) {
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

