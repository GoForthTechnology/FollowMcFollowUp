import 'package:flutter/material.dart';

class FupFormScreen extends StatefulWidget {
  static const String routeName = "fupf";

  @override
  State<StatefulWidget> createState() => _FupFormScreenState();
}

class _FupFormScreenState extends State<FupFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up Form"),
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(20), child: BoxGridWidget(
        rowLabels: ["A", "B", "C"],
      ))),
    );
  }
}

class BoxGridWidget extends StatelessWidget {
  final List<String> rowLabels;
  final int nColumns;

  BoxGridWidget({required this.rowLabels, this.nColumns = 8});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    List<Widget> cells = [];
    for (int i=0; i<nColumns; i++) {
      cells.add(LegendCell(text: (i+1).toString()));
    }
    rows.add(Row(children: cells));
    for (int i=0; i<rowLabels.length; i++) {
      List<Widget> cells = [];
      for (int j=0; j<nColumns; j++) {
        cells.add(BoxWidget());
      }
      rows.add(Row(children: cells));
    }
    Widget grid = Expanded(child: Stack(children: [
      Positioned(
        left: 5,
        top: 35,
        child: Container(
          width: 30.0 * nColumns,
          height: 30.0 * rowLabels.length,
          color: Colors.black,
        ),
      ),
      Column(children: rows),
    ]));

    List<Widget> labels = [];
    labels.add(const LegendCell(text: ""));
    for (int i = 0; i < rowLabels.length; i++) {
      labels.add(LegendCell(text: rowLabels[i]));
    }
    return Row(children: [
      Column(children: labels),
      grid,
    ],);
  }
}

class LegendCell extends StatelessWidget {
  final String text;

  const LegendCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30, height: 30,
      child: Center(child: Text(text)),
    );
  }
}

class BoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black), color: Colors.white),
      width: 30,
      height: 30,
    );
  }
}