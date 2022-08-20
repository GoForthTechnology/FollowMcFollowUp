
import 'dart:math';
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
              const ControlBar(),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    itemCount: model.cycles.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _createHeaderRow();
                      }
                      return _createCycleRow(index-1, context, model.cycles, corrections, (rowIndex, observationIndex, sticker) {
                        setState(() {
                          corrections.putIfAbsent(rowIndex, () => {});
                          var correctionsRow = corrections[rowIndex]!;
                          if (sticker == null) {
                            correctionsRow.remove(observationIndex);
                          } else {
                            correctionsRow[observationIndex] = sticker;
                          }
                        });
                      });
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

Widget _createCycleRow(int rowIndex, BuildContext context, Cycles cycles, Corrections corrections, void Function(int, int, StickerWithText?) updateCorrections) {
  List<Widget> sections = [];
  for (int i=0; i<nSectionsPerCycle; i++) {
    sections.add(_createSection(rowIndex, i, context, cycles, corrections, updateCorrections));
  }
  return Row(children: sections);
}

Widget _createSection(int rowIndex, int sectionIndex, BuildContext context, Cycles cycles, Corrections corrections, void Function(int, int, StickerWithText?) updateCorrection) {
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

List<Widget> _entries(
    int rowIndex,
    int sectionIndex,
    BuildContext context,
    Cycles cycles,
    Corrections corrections,
    void Function(int, int, StickerWithText?) updateCorrection) {
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
      observation?.getStickerText(),
      _showCorrectionDialog(context, rowIndex, observationIndex, null, updateCorrection),
    );
    StickerWithText? correction = corrections[rowIndex]?[observationIndex];
    if (observation != null && correction != null) {
      sticker = Stack(children: [
        sticker,
        Transform.rotate(
          angle: -pi / 12.0,
          child: _createSticker(
            correction.sticker,
            correction.text,
            _showCorrectionDialog(context, rowIndex, observationIndex, correction, updateCorrection),
          ),
        )
      ]);
    }
    Widget observationText = _createCell(
        Text(
          observation == null ? "" : observation.getObservationText(),
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
        Colors.white, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Entry click: cycle #${rowIndex+1}')),
          );
        });
    stackedCells.add(Column(children: [sticker, observationText]));
  }
  return stackedCells;
}

void Function() _showCorrectionDialog(
    BuildContext context,
    int rowIndex,
    int observationIndex,
    StickerWithText? existingCorrection,
    void Function(int, int, StickerWithText?) updateCorrection) {
  return () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Sticker? selectedSticker = existingCorrection?.sticker;
        String? selectedStickerText = existingCorrection?.text;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Sticker Correction'),
            content: _createStickerCorrectionContent(selectedSticker, selectedStickerText, (sticker) {
              setState(() {
                print("Selected sticker: $sticker");
                if (selectedSticker == sticker) {
                  selectedSticker = null;
                } else {
                  selectedSticker = sticker;
                }
              });
            }, (text) {
              setState(() {
                print("Selected text: $text");
                if (selectedStickerText == text) {
                  selectedStickerText = null;
                } else {
                  selectedStickerText = text;
                }
              });
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  StickerWithText? stickerWithText;
                  if (selectedSticker != null) {
                    stickerWithText = StickerWithText(selectedSticker!, selectedStickerText);
                  }
                  updateCorrection(rowIndex, observationIndex, stickerWithText);
                  Navigator.pop(context, 'OK');
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
      },
    );
  };
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

Widget _createStickerCorrectionContent(Sticker? selectedSticker, String? selectedStickerText, void Function(Sticker?) onSelectSticker, void Function(String?) onSelectText) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Padding(padding: EdgeInsets.all(10), child: Text("Select the correct sticker")),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _createDialogSticker(Sticker.red, selectedSticker, onSelectSticker),
          _createDialogSticker(Sticker.green, selectedSticker, onSelectSticker),
          _createDialogSticker(Sticker.greenBaby, selectedSticker, onSelectSticker),
          _createDialogSticker(Sticker.whiteBaby, selectedSticker, onSelectSticker),
        ],
      ),
      const Padding(padding: EdgeInsets.all(10), child: Text("Select the correct text")),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _createDialogTextSticker("", selectedStickerText, onSelectText),
          _createDialogTextSticker("P", selectedStickerText, onSelectText),
          _createDialogTextSticker("1", selectedStickerText, onSelectText),
          _createDialogTextSticker("2", selectedStickerText, onSelectText),
          _createDialogTextSticker("3", selectedStickerText, onSelectText),
        ],
      ),
    ],
  );
}

Widget _createDialogSticker(Sticker sticker, Sticker? selectedSticker, void Function(Sticker?) onSelect) {
  Widget child = _createSticker(sticker, "", () => onSelect(sticker));
  if (selectedSticker == sticker) {
    child = Container(
      decoration: BoxDecoration(
        border: Border.all(color:Colors.black),
      ),
      child: child,
    );
  }
  return Padding(padding: const EdgeInsets.all(2), child: child);
}

Widget _createDialogTextSticker(String text, String? selectedText, void Function(String?) onSelect) {
  Widget sticker = _createSticker(Sticker.white, text, () => onSelect(text));
  if (selectedText == text) {
    sticker = Container(
      decoration: BoxDecoration(
        border: Border.all(color:Colors.black),
      ),
      child: sticker,
    );
  }
  return Padding(padding: const EdgeInsets.all(2), child: sticker);
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

class ControlBar extends StatefulWidget {
  static ControlBarState of(BuildContext context) => context.findAncestorStateOfType<ControlBarState>()!;

  const ControlBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ControlBarState();
}


class ControlBarState extends State<ControlBar> {

  double unusualBleedingFrequency = CycleRecipe.defaultUnusualBleedingFrequency;
  double prePeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  double prePeakPeakTypeFrequency = CycleRecipe.defaultPrePeakPeakTypeFrequency;
  double postPeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  int flowLength = CycleRecipe.defaultFlowLength;
  int preBuildupLength = CycleRecipe.defaultPreBuildupLength;
  int buildUpLength = CycleRecipe.defaultBuildUpLength;
  int peakTypeLength = CycleRecipe.defaultPeakTypeLength;
  int postPeakLength = CycleRecipe.defaultPostPeakLength;
  bool askESQ = false;
  bool prePeakYellowStamps = false;
  bool postPeakYellowStamps = false;

  CycleRecipe _getRecipe() {
    return CycleRecipe.create(
        unusualBleedingFrequency / 100,
        prePeakMucusPatchFrequency / 100,
        prePeakPeakTypeFrequency / 100,
        postPeakMucusPatchFrequency / 100,
        flowLength,
        preBuildupLength,
        buildUpLength,
        peakTypeLength,
        postPeakLength,
        askESQ);
  }

  @override
  Widget build(BuildContext context) {
    void updateCycles(CycleViewModel model) {
      model.updateCycles(
          _getRecipe(),
          askESQ: askESQ, prePeakYellowStamps: prePeakYellowStamps,
          postPeakYellowStamps: postPeakYellowStamps);
    }
    return Consumer<CycleViewModel>(
      builder: (context, model, child) => Column(
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
                updateCycles(model);
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
                updateCycles(model);
              });
            },
          ),
          const Text("Pre-Peak Peak Type Mucus: "),
          Text((prePeakPeakTypeFrequency / 100).toString()),
          Slider(
            value: prePeakPeakTypeFrequency,
            min: 0,
            max: 100,
            divisions: 10,
            onChanged: (val) {
              setState(() {
                prePeakPeakTypeFrequency = val;
                updateCycles(model);
              });
            },
          ),
          const Text("Post-Peak Mucus: "),
          Text((postPeakMucusPatchFrequency / 100).toString()),
          Slider(
            value: postPeakMucusPatchFrequency,
            min: 0,
            max: 100,
            divisions: 10,
            onChanged: (val) {
              setState(() {
                postPeakMucusPatchFrequency = val;
                updateCycles(model);
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
                    updateCycles(model);
                  }
                });
              }, child: const Text("-")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(onPressed: () {
                setState(() {
                  flowLength++;
                  updateCycles(model);
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
                    updateCycles(model);
                  }
                });
              }, child: const Text("-")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(onPressed: () {
                setState(() {
                  preBuildupLength++;
                  updateCycles(model);
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
                    updateCycles(model);
                  }
                });
              }, child: const Text("-")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(onPressed: () {
                setState(() {
                  buildUpLength++;
                  updateCycles(model);
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
                    updateCycles(model);
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
                  updateCycles(model);
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
                    updateCycles(model);
                  }
                });
              }, child: const Text("-")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(onPressed: () {
                setState(() {
                  postPeakLength++;
                  updateCycles(model);
                });
              }, child: const Text("+")),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Ask ESQ: "),
            Switch(value: askESQ, onChanged: (value) {
              setState(() {
                askESQ = value;
                if (!askESQ) {
                  prePeakYellowStamps = false;
                }
                updateCycles(model);
              });
            }),
            const Text("Pre-Peak Yellow Stamps: "),
            Switch(value: prePeakYellowStamps, onChanged: (value) {
              setState(() {
                prePeakYellowStamps = value;
                if (prePeakYellowStamps) {
                  askESQ = true;
                }
                updateCycles(model);
              });
            }),
            const Text("Post-Peak Yellow Stamps: "),
            Switch(value: postPeakYellowStamps, onChanged: (value) {
              setState(() {
                postPeakYellowStamps = value;
                updateCycles(model);
              });
            }),
          ],
        )
      ],
    ));
  }
}

