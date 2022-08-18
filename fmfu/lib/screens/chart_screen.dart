
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fmfu/models/observation.dart';
import 'package:fmfu/models/stickers.dart';
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
typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _ChartPageState extends State<ChartPage> {

  double unusualBleedingFrequency = CycleRecipe.defaultUnusualBleedingFrequency;
  double prePeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  double postPeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  int flowLength = CycleRecipe.defaultFlowLength;
  int preBuildupLength = CycleRecipe.defaultPreBuildupLength;
  int buildUpLength = CycleRecipe.defaultBuildUpLength;
  int peakTypeLength = CycleRecipe.defaultPeakTypeLength;
  int postPeakLength = CycleRecipe.defaultPostPeakLength;
  Corrections corrections = {};

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
                    return _createCycleRow(index-1, context, cycles, corrections, (rowIndex, observationIndex, sticker) {
                      setState(() {
                        corrections.putIfAbsent(rowIndex, () => {});
                        var correctionsRow = corrections[rowIndex]!;
                        correctionsRow[observationIndex] = sticker;
                      });
                    });
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

Widget _createCycleRow(int rowIndex, BuildContext context, Cycles cycles, Corrections corrections, void Function(int, int, StickerWithText) updateCorrections) {
  List<Widget> sections = [];
  for (int i=0; i<nSectionsPerCycle; i++) {
    sections.add(_createSection(rowIndex, i, context, cycles, corrections, updateCorrections));
  }
  return Row(children: sections);
}

Widget _createSection(int rowIndex, int sectionIndex, BuildContext context, Cycles cycles, Corrections corrections, void Function(int, int, StickerWithText) updateCorrection) {
  return
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: _entries(rowIndex, sectionIndex, context, cycles, corrections, updateCorrection),
      ),
    );
}

void _onStickerSelect(Sticker? sticker) {

}

List<Widget> _entries(
    int rowIndex,
    int sectionIndex,
    BuildContext context,
    Cycles cycles,
    Corrections corrections,
    void Function(int, int, StickerWithText) updateCorrection) {
  List<Widget> stackedCells = [];
  for (int i=0; i<nEntriesPerSection; i++) {
    List<RenderedObservation> observations = cycles[rowIndex];
    int observationIndex = sectionIndex * nEntriesPerSection + i;
    RenderedObservation? observation;
    if (observationIndex < observations.length) {
      observation = observations[observationIndex];
    }
    Widget sticker = _createSticker(
        observation?.getSticker(),
        observation?.getStickerText(), () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Sticker? selectedSticker;
              String? selectedStickerText;
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Sticker Correction'),
                  content: _createStickerCorrectionContent((sticker) {
                    setState(() {
                      print("Selected sticker: $sticker");
                      selectedSticker = sticker;
                    });
                  }, (text) {
                    setState(() {
                      print("Selected text: $text");
                      selectedStickerText = text;
                    });
                  }),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedSticker == null) {
                          return;
                        }
                        updateCorrection(rowIndex, observationIndex, StickerWithText(selectedSticker!, selectedStickerText));
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
            },
          );
        });
    StickerWithText? correction = corrections[rowIndex]?[observationIndex];
    if (observation != null && correction != null) {
      sticker = Stack(children: [
        sticker,
        Transform.rotate(
          angle: -pi / 12.0,
          child: _createSticker(correction.sticker, correction.text, () => {}),
        )
      ]);
    }
    Widget observationText = _createCell(
        Text(observation == null ? "" : observation.observationText),
        Colors.white, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Entry click: cycle #${rowIndex+1}')),
          );
        });
    stackedCells.add(Column(children: [sticker, observationText]));
  }
  return stackedCells;
}

Widget _createSticker(Sticker? sticker, String? stickerText, void Function() onTap) {
  Widget content = Container();
  Color stickerBackgroundColor = Colors.white;
  if (sticker != null) {
    stickerBackgroundColor = sticker.color;
    content =  Stack(
      alignment: Alignment.center,
      children: [
        Text(
          stickerText ?? "", textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Icon(
          sticker.showBaby ? Icons.child_care : null,
          color: Colors.black12,
        )
      ],
    );
  }
  return _createCell(content, stickerBackgroundColor, onTap);
}

Widget _createStickerCorrectionContent(void Function(Sticker?) onSelectSticker, void Function(String?) onSelectText) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Padding(padding: EdgeInsets.all(10), child: Text("Select the correct sticker")),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _padAllWith(2, _createSticker(Sticker.red, "", () => onSelectSticker(Sticker.red))),
          _padAllWith(2, _createSticker(Sticker.green, "", () => onSelectSticker(Sticker.green))),
          _padAllWith(2, _createSticker(Sticker.greenBaby, "", () => onSelectSticker(Sticker.greenBaby))),
          _padAllWith(2, _createSticker(Sticker.whiteBaby, "", () => onSelectSticker(Sticker.whiteBaby))),
        ],
      ),
      const Padding(padding: EdgeInsets.all(10), child: Text("Select the correct text")),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _padAllWith(2, _createSticker(Sticker.white, "", () => onSelectText(""))),
          _padAllWith(2, _createSticker(Sticker.white, "P", () => onSelectText("P"))),
          _padAllWith(2, _createSticker(Sticker.white, "1", () => onSelectText("1"))),
          _padAllWith(2, _createSticker(Sticker.white, "2", () => onSelectText("2"))),
          _padAllWith(2, _createSticker(Sticker.white, "3", () => onSelectText("3"))),
        ],
      ),
    ],
  );
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

Widget _padAllWith(double padding, Widget child) {
  return Padding(padding: EdgeInsets.all(padding), child: child);
}
