
import 'package:flutter/material.dart';
import 'package:fmfu/models/observation.dart';
import 'package:fmfu/utils/cycle_generation.dart';
import 'package:fmfu/utils/cycle_rendering.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  static List<List<RenderedObservation>> cycles = List.generate(
      50, (i) => renderObservations(CycleRecipe.standardRecipe.getObservations()));

  @override
  State<StatefulWidget> createState() => _ChartPageState();
}

typedef Cycles = List<List<RenderedObservation>>;

class _ChartPageState extends State<ChartPage> {

  double unusualBleedingFrequency = CycleRecipe.defaultUnusualBleedingFrequency;
  double prePeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  double postPeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  int flowLength = CycleRecipe.defaultFlowLength;
  int preBuildupLength = CycleRecipe.defaultPreBuildupLength;
  int buildUpLength = CycleRecipe.defaultBuildUpLength;
  int peakTypeLength = CycleRecipe.defaultPeakTypeLength;
  int postPeakLength = CycleRecipe.defaultPostPeakLength;

  @override
  Widget build(BuildContext context) {
    CycleRecipe recipe = CycleRecipe.create(
      unusualBleedingFrequency / 100,
      prePeakMucusPatchFrequency / 100,
      postPeakMucusPatchFrequency / 100,
      flowLength,
      preBuildupLength,
      buildUpLength,
      peakTypeLength,
      postPeakLength,
    );
    var cycles = List.generate(50, (index) => renderObservations(recipe.getObservations()));
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Grid Page"),
      ),
      // TODO: figure out how to make horizontal scrolling work...
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Column(
              children: [
                Row(children: [
                  const Text("Unusual Bleeding: "),
                  Text((unusualBleedingFrequency / 100).toString()),
                  Slider(
                    value: unusualBleedingFrequency,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (val) {
                      setState(() {
                        unusualBleedingFrequency = val;
                      });
                    },
                  ),
                  const Text("Pre-Peak Mucus Patch: "),
                  Text((prePeakMucusPatchFrequency / 100).toString()),
                  Slider(
                    value: prePeakMucusPatchFrequency,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (val) {
                      setState(() {
                        prePeakMucusPatchFrequency = val;
                      });
                    },
                  ),
                  const Text("Post-Peak Mucus Patch: "),
                  Text((postPeakMucusPatchFrequency / 100).toString()),
                  Slider(
                    value: postPeakMucusPatchFrequency,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (val) {
                      setState(() {
                        postPeakMucusPatchFrequency = val;
                      });
                    },
                  ),
                ]),
                Row(
                  children: [
                    const Text("Flow Length: "),
                    Text(flowLength.toString()),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          if (flowLength > 0) {
                            flowLength--;
                          }
                        });
                      }, child: const Text("-")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          flowLength++;
                        });
                      }, child: const Text("+")),
                    ),
                    const Text("Pre Buildup Length:"),
                    Text(preBuildupLength.toString()),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          if (preBuildupLength > 0) {
                            preBuildupLength--;
                          }
                        });
                      }, child: const Text("-")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          preBuildupLength++;
                        });
                      }, child: const Text("+")),
                    ),
                    const Text("Buildup Length:"),
                    Text(buildUpLength.toString()),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          if (buildUpLength > 0) {
                            buildUpLength--;
                          }
                        });
                      }, child: const Text("-")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          buildUpLength++;
                        });
                      }, child: const Text("+")),
                    ),
                    const Text("Peak Type Length:"),
                    Text(peakTypeLength.toString()),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          if (peakTypeLength > 0) {
                            peakTypeLength--;
                          }
                        });
                      }, child: const Text("-")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(onPressed: () {
                        if (peakTypeLength == buildUpLength) {
                          return;
                        }
                        setState(() {
                          peakTypeLength++;
                        });
                      }, child: const Text("+")),
                    ),
                    const Text("Post Peak Length:"),
                    Text(postPeakLength.toString()),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          if (postPeakLength > 0) {
                            postPeakLength--;
                          }
                        });
                      }, child: const Text("-")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(onPressed: () {
                        setState(() {
                          postPeakLength++;
                        });
                      }, child: const Text("+")),
                    ),
                  ],
                )
              ],
            ),
            Expanded(child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: cycles.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _createHeaderRow();
                    }
                    return _createCycleRow(index-1, context, cycles);
                  },
                ),
            )),
          ],
        ),
      ),
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

Widget _createCycleRow(int rowIndex, BuildContext context, Cycles cycles) {
  List<Widget> sections = [];
  for (int i=0; i<nSectionsPerCycle; i++) {
    sections.add(_createSection(rowIndex, i, context, cycles));
  }
  return Row(children: sections);
}

Widget _createSection(int rowIndex, int sectionIndex, BuildContext context, Cycles cycles) {
  return
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: _entries(rowIndex, sectionIndex, context, cycles),
      ),
    );
}

List<Widget> _entries(int rowIndex, int sectionIndex, BuildContext context, Cycles cycles) {
  List<Widget> stackedCells = [];
  for (int i=0; i<nEntriesPerSection; i++) {
    List<RenderedObservation> observations = cycles[rowIndex];
    int observationIndex = sectionIndex * nEntriesPerSection + i;
    RenderedObservation? observation;
    if (observationIndex < observations.length) {
      observation = observations[observationIndex];
    }
    Widget sticker = Container();
    Color stickerBackgroundColor = Colors.white;
    if (observation != null) {
      stickerBackgroundColor = observation.getSticker().color;
      sticker = Stack(
        alignment: Alignment.center,
        children: [
          Text(observation.getStickerText(), textAlign: TextAlign.center),
          Icon(
            observation.getSticker().showBaby ? Icons.child_care : null,
            color: Colors.black12,
          )
        ],
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
        _createCell(Text(observation == null ? "" : observation.observationText), Colors.white, () {
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
