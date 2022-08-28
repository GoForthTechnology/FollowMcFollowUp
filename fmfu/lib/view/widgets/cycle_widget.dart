import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/cycle_stats_widget.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';

class CycleWidget extends StatefulWidget {
  final Cycle? cycle;
  final bool showStats;
  final int dayOffset;

  static const int nSectionsPerCycle = 5;
  static const int nEntriesPerSection = 7;

  const CycleWidget({Key? key, required this.cycle, this.showStats = true, this.dayOffset = 0}) : super(key: key);

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
    if (widget.showStats && widget.dayOffset == 0) {
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
      int entryIndex = sectionIndex * CycleWidget.nEntriesPerSection + i + widget.dayOffset;
      ChartEntry? entry;
      RenderedObservation? observation;
      var hasCycle = widget.cycle != null;
      if (hasCycle && entryIndex < widget.cycle!.entries.length) {
        entry = widget.cycle?.entries[entryIndex];
        observation = entry?.renderedObservation;
      }
      Widget sticker = StickerWidget(
        sticker: observation?.getSticker(),
        stickerText: observation?.getStickerText(),
        onTap: observation != null ? _showCorrectionDialog(context, entryIndex, null) : () {},
      );
      StickerWithText? correction = widget.cycle?.corrections[entryIndex];
      if (observation != null && correction != null) {
        sticker = Stack(children: [
          sticker,
          Transform.rotate(
            angle: -pi / 12.0,
            child: StickerWidget(
              sticker: correction.sticker,
              stickerText: correction.text,
              onTap: _showCorrectionDialog(context, entryIndex, correction),
            ),
          )
        ]);
      }
      Widget observationText = ChartCellWidget(
          content: Text(
            entry == null ? "" : entry.observationText,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          onTap: (entry == null) ? () {} : _showEditDialog(context, entryIndex, entry),
      );
      stackedCells.add(Column(children: [sticker, observationText]));
    }
    return stackedCells;
  }

  void Function() _showEditDialog(
      BuildContext context,
      int entryIndex,
      ChartEntry entry) {
    return () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var formKey = GlobalKey<FormState>();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Observation Edit'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: entry.observationText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value == null) {
                      throw Exception("Validation should have prevented saving a null value");
                    }
                    editChartEntry(entryIndex, value);
                  },
                )
              ),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Navigator.pop(context, 'OK');
                    }
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

  void Function() _showCorrectionDialog(
      BuildContext context,
      int entryIndex,
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
                    updateCorrections(entryIndex, correction);
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

  void editChartEntry(int entryIndex, String observationText) {
    setState(() {
      print("Editing $entryIndex to $observationText");
      widget.cycle!.entries[entryIndex].observationText = observationText;
    });
  }

  void updateCorrections(int entryIndex, StickerWithText? correction) {
    setState(() {
      if (widget.cycle == null) {
        return;
      }
      if (correction == null) {
        widget.cycle!.corrections.remove(entryIndex);
      } else {
        widget.cycle!.corrections[entryIndex] = correction;
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