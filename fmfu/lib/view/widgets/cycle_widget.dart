import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/cycle_stats_widget.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';

class CycleWidget extends StatefulWidget {
  final Cycle cycle;
  final bool showStats;

  static const int nSectionsPerCycle = 5;
  static const int nEntriesPerSection = 7;

  const CycleWidget({Key? key, required this.cycle, this.showStats = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CycleWidgetState();
}

class CycleWidgetState extends State<CycleWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [];
    for (int i=0; i<CycleWidget.nSectionsPerCycle; i++) {
      sections.add(_createSection(context, i));
    }
    if (widget.showStats) {
      sections.add(const CycleStatsWidget());
    }
    return Row(children: sections);
  }

  Widget _createSection(BuildContext context, int sectionIndex) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: _createEntries(context, sectionIndex),
        ),
      );
  }

  List<Widget> _createEntries(BuildContext context, int sectionIndex) {
    List<Widget> stackedCells = [];
    for (int i=0; i<CycleWidget.nEntriesPerSection; i++) {
      int observationIndex = sectionIndex * CycleWidget.nEntriesPerSection + i;
      RenderedObservation? observation;
      if (observationIndex < widget.cycle.observations.length) {
        observation = widget.cycle.observations[observationIndex];
      }
      Widget sticker = StickerWidget(
        sticker: observation?.getSticker(),
        stickerText: observation?.getStickerText(),
        onTap: _showCorrectionDialog(context, observationIndex, null),
      );
      StickerWithText? correction = widget.cycle.corrections[observationIndex];
      if (observation != null && correction != null) {
        sticker = Stack(children: [
          sticker,
          Transform.rotate(
            angle: -pi / 12.0,
            child: StickerWidget(
              sticker: correction.sticker,
              stickerText: correction.text,
              onTap: _showCorrectionDialog(context, observationIndex, correction),
            ),
          )
        ]);
      }
      Widget observationText = ChartCellWidget(
          content: Text(
            observation == null ? "" : observation.getObservationText(),
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          onTap: () {},
      );
      stackedCells.add(Column(children: [sticker, observationText]));
    }
    return stackedCells;
  }

  void Function() _showCorrectionDialog(
      BuildContext context,
      int observationIndex,
      StickerWithText? existingCorrection) {
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
                    StickerWithText? correction;
                    if (selectedSticker != null) {
                      correction = StickerWithText(selectedSticker!, selectedStickerText);
                    }
                    updateCorrections(observationIndex, correction);
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

  void updateCorrections(int observationIndex, StickerWithText? correction) {
    setState(() {
      if (correction == null) {
        widget.cycle.corrections.remove(observationIndex);
      } else {
        widget.cycle.corrections[observationIndex] = correction;
      }
    });
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
    Widget child = StickerWidget(sticker: sticker, onTap: () => onSelect(sticker));
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
    Widget sticker = StickerWidget(sticker: Sticker.white, stickerText: text, onTap: () => onSelect(text));
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
}