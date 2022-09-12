import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/cycle_stats_widget.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

class CycleWidget extends StatefulWidget {
  final Cycle? cycle;
  final bool showStats;
  final int dayOffset;
  final bool editingEnabled;
  final bool showErrors;

  static const int nSectionsPerCycle = 5;
  static const int nEntriesPerSection = 7;

  const CycleWidget({Key? key, required this.cycle, required this.editingEnabled, required this.showErrors, this.showStats = true, this.dayOffset = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CycleWidgetState();
}

class CycleWidgetState extends State<CycleWidget> with UiLoggy {
  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [];
    for (int i=0; i<CycleWidget.nSectionsPerCycle; i++) {
      sections.add(_createSection(context, i));
    }
    if (widget.cycle != null && widget.showStats && widget.dayOffset == 0 && !widget.editingEnabled ) {
      sections.add(CycleStatsWidget(cycle: widget.cycle!));
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
      StickerWithText? sticker = entry?.manualSticker;
      if (sticker == null && observation != null) {
        sticker = StickerWithText(observation.getSticker(), observation.getStickerText());
      }
      Widget stickerWidget = StickerWidget(
        stickerWithText: sticker,
        onTap: observation != null ? _showCorrectionDialog(context, entryIndex, null) : () {},
      );
      StickerWithText? stickerCorrection = widget.cycle?.stickerCorrections[entryIndex];
      if (observation != null && stickerCorrection != null) {
        stickerWidget = Stack(children: [
          stickerWidget,
          Transform.rotate(
            angle: -pi / 12.0,
            child: StickerWidget(
              stickerWithText: StickerWithText(
                stickerCorrection.sticker, stickerCorrection.text,
              ),
              onTap: _showCorrectionDialog(context, entryIndex, stickerCorrection),
            ),
          )
        ]);
      }
      var textBackgroundColor = Colors.white;
      if (widget.showErrors && (entry?.hasErrors() ?? false)) {
        textBackgroundColor = const Color(0xFFEECDCD);
      }
      String? observationCorrection = widget.cycle?.observationCorrections[entryIndex];
      bool hasObservationCorrection = observation != null && observationCorrection != null;
      var content = RichText(text: TextSpan(
        style: const TextStyle(fontSize: 10),
        children: [
          TextSpan(
            text: entry == null ? "" : entry.observationText,
            style: hasObservationCorrection ? const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 10) : null,
          ),
          if (hasObservationCorrection) TextSpan(
            text: "\n$observationCorrection",
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ));
      Widget observationText = ChartCellWidget(
        content: content,
        /*content: Text(
          content,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),*/
        backgroundColor: textBackgroundColor,
        onTap: (entry == null) ? () {} : _showEditDialog(context, entryIndex, entry, observationCorrection),
      );
      stackedCells.add(Column(children: [stickerWidget, observationText]));
    }
    return stackedCells;
  }

  void Function() _showEditDialog(
      BuildContext context,
      int entryIndex,
      ChartEntry entry,
      String? correction) {
    return () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var formKey = GlobalKey<FormState>();
          var cycleIndex = widget.cycle!.index;
          return Consumer<ChartListViewModel>(builder: (context, model, child) => StatefulBuilder(builder: (context, setState) => AlertDialog(
            title: Text(model.editEnabled ? "Edit Observation" : "Correct Observation"),
            content: Form(
              key: formKey,
              child: TextFormField(
                initialValue: model.editEnabled ? entry.observationText : correction ?? entry.observationText,
                validator: (value) {
                  if (!model.editEnabled && (value == null || value.isEmpty)) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (model.editEnabled) {
                    if (value == null) {
                      throw Exception(
                          "Validation should have prevented saving a null value");
                    }
                    loggy.debug("Editing entry to be $value for cycle #$cycleIndex, entry #$entryIndex");
                    model.editEntry(cycleIndex, entryIndex, value);
                  } else {
                    loggy.debug("Updating observation correction to be $value for cycle #$cycleIndex, entry #$entryIndex");
                    model.updateObservationCorrections(cycleIndex, entryIndex, value);
                  }
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              if (!model.editEnabled && correction != null) TextButton(
                onPressed: () {
                  model.updateObservationCorrections(cycleIndex, entryIndex, null);
                  Navigator.pop(context, 'CLEAR');
                },
                child: const Text('Clear'),
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
          )));
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
            return Consumer<ChartListViewModel>(
                builder: (context, model, child) => AlertDialog(
              title: const Text('Sticker Correction'),
              content: _createStickerCorrectionContent(selectedSticker, selectedStickerText, (sticker) {
                setState(() {
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
                    if (!widget.editingEnabled) {
                      model.updateStickerCorrections(widget.cycle!.index, entryIndex, correction);
                    } else {
                      model.editSticker(widget.cycle!.index, entryIndex, correction);
                    }
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
          });
        },
      );
    };
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
    Widget child = StickerWidget(stickerWithText: StickerWithText(sticker, null), onTap: () => onSelect(sticker));
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
    Widget sticker = StickerWidget(stickerWithText: StickerWithText(Sticker.white, text), onTap: () => onSelect(text));
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