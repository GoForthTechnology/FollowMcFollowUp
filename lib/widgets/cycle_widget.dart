import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/widgets/chart_cell_widget.dart';
import 'package:fmfu/widgets/chart_row_widget.dart';
import 'package:fmfu/widgets/chart_widget.dart';
import 'package:fmfu/widgets/sticker_widget.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:loggy/loggy.dart';
import 'package:time_machine/time_machine.dart' as time;

class CycleWidget extends StatefulWidget {
  final Cycle? cycle;
  final int dayOffset;
  final bool correctingEnabled;
  final bool editingEnabled;
  final bool showErrors;
  final bool autoStamp;
  final SoloCell? soloCell;
  final ChartViewModel model;
  final Widget? Function(Cycle?) rightWidgetFn;

  static const int nSectionsPerCycle = 5;
  static const int nEntriesPerSection = 7;

  const CycleWidget({
    required this.cycle,
    required this.model,
    this.editingEnabled = false,
    this.correctingEnabled = false,
    this.showErrors = false,
    this.autoStamp = true,
    this.dayOffset = 0,
    this.soloCell,
    super.key, required this.rightWidgetFn,
  });

  @override
  State<StatefulWidget> createState() => CycleWidgetState();
}

class CycleWidgetState extends State<CycleWidget> with UiLoggy {
  @override
  Widget build(BuildContext context) {
    return ChartRowWidget(
      dayOffset: widget.dayOffset,
      topCellCreator: _createStickerCell,
      bottomCellCreator: _createObservationCell,
      rightWidget: widget.rightWidgetFn(widget.cycle),
    );
  }

  ChartEntry? _getChartEntry(int entryIndex) {
    if (entryIndex >= widget.cycle!.entries.length) {
      return null;
    }
    var hasCycle = widget.cycle != null;
    if (widget.soloCell == null && hasCycle && entryIndex < widget.cycle!.entries.length) {
      return widget.cycle?.entries[entryIndex];
    } else if (widget.soloCell != null && widget.soloCell!.entryIndex >= entryIndex) {
      return widget.cycle?.entries[entryIndex];
    }
    return null;
  }

  bool _shouldSuppress(time.LocalDate? entryDate) {
    if (entryDate == null) {
      return false;
    }
    var currentFollowUpDate = widget.model.currentFollowUpDate();
    bool suppressForFollowup = currentFollowUpDate != null && entryDate > currentFollowUpDate;
    bool suppressForStartOfCharting = entryDate < widget.model.startOfCharting();
    return suppressForFollowup || suppressForStartOfCharting;
  }

  Widget _createObservationCell(int entryIndex) {
    var entry = _getChartEntry(entryIndex);
    time.LocalDate? entryDate = entry?.renderedObservation?.date;
    var shouldSuppress = _shouldSuppress(entryDate);

    var textBackgroundColor = Colors.white;
    if (widget.showErrors && (entry?.hasErrors() ?? false) && !shouldSuppress) {
      textBackgroundColor = const Color(0xFFEECDCD);
    }
    String? observationCorrection = widget.cycle?.observationCorrections[entryIndex];
    if (shouldSuppress) {
      entry = null;
    }
    bool hasFollowup = entryDate != null && widget.model.followUps().contains(entryDate);
    Widget content = CustomPaint(
      painter: ObservationPainter(
        entry,
        observationCorrection,
        drawOval: entry != null && hasFollowup,
      ),
    );
    var canShowDialog = widget.editingEnabled || widget.correctingEnabled;
    return ChartCellWidget(
      alignment: Alignment.topCenter,
      content: content,
      backgroundColor: textBackgroundColor,
      onTap: (!canShowDialog || entry == null) ? () {} : _showObservationDialog(context, entryIndex, entry, observationCorrection),
      onLongPress: () {
        if (kDebugMode) {
          print(entry?.toJson());
        }
      },
    );
  }

  Widget _createStickerCell(int entryIndex) {
    var soloingCell = widget.soloCell != null && widget.soloCell!.entryIndex == entryIndex;
    var alreadySoloed = widget.soloCell != null && widget.soloCell!.entryIndex > entryIndex;
    var entry = _getChartEntry(entryIndex);
    RenderedObservation? observation = entry?.renderedObservation;

    StickerWithText? sticker = entry?.manualSticker;
    if (sticker == null && widget.autoStamp && observation != null) {
      sticker = observation.getStickerWithText();
    }
    var entryDate = entry?.renderedObservation?.date;
    if (_shouldSuppress(entryDate)) {
      sticker = null;
    }
    if (soloingCell && sticker == null) {
      sticker = StickerWithText(Sticker.grey, "?");
    }
    var showStickerDialog = !soloingCell || alreadySoloed || (soloingCell && (observation != null || entry?.manualSticker != null));
    Widget stickerWidget = StickerWidget(
      stickerWithText: sticker,
      onTap: showStickerDialog ? _showCorrectionDialog(context, entryIndex, /*this is sketchy*/entry?.manualSticker) : () {},
    );
    StickerWithText? stickerCorrection = widget.cycle?.stickerCorrections[entryIndex];
    if (showStickerDialog && stickerCorrection != null) {
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
    return stickerWidget;
  }

  void Function() _showObservationDialog(
      BuildContext context,
      int entryIndex,
      ChartEntry entry,
      String? correction) {
    return () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ObservationDialog(
            cycle: widget.cycle!,
            entry: entry,
            entryIndex: entryIndex,
            editEnabled: widget.editingEnabled,
            model: widget.model,
          );
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
          return StickerCorrectionDialog(
            model: widget.model,
            entryIndex: entryIndex,
            cycle: widget.cycle!,
            editingEnabled: widget.editingEnabled,
            existingCorrection: existingCorrection,
          );
        },
      );
    };
  }
}

class ObservationPainter extends CustomPainter {
  final ChartEntry? entry;
  final String? observationCorrection;
  final bool drawOval;

  ObservationPainter(this.entry, this.observationCorrection, {this.drawOval = false});

  @override
  void paint(Canvas canvas, Size size) {
    _drawText(canvas, size);
    if (drawOval) {
      _drawOval(canvas);
    }
  }

  void _drawText(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(
      text: _getText(),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    const yCenter = 0.0;
    final Offset offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  void _drawOval(Canvas canvas) {
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
    ;
    canvas.drawOval(Rect.fromCenter(
      center: const Offset(0, 6),
      width: 36,
      height: 20,
    ), paint);
  }

  TextSpan _getText() {
    RenderedObservation? observation = entry?.renderedObservation;
    bool hasObservationCorrection = (observation != null || entry?.manualSticker != null) && observationCorrection != null;
    String? dateString = entry?.renderedObservation?.date?.toString("MM/dd");
    String observationText = [entry?.observationText, entry?.additionalText]
        .where((e) => e != null)
        .join("\n");
    return TextSpan(
      style: const TextStyle(fontSize: 10, color: Colors.black),
      children: [
        if (dateString != null) TextSpan(
          text: "$dateString\n",
        ),
        const TextSpan(
          text: "\n",
          style: TextStyle(fontSize: 5),
        ),
        TextSpan(
          text: observationText,
          style: hasObservationCorrection ? const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 10) : null,
        ),
        if (hasObservationCorrection) TextSpan(
          text: "\n$observationCorrection",
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ],
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StickerCorrectionDialog extends StatelessWidget with UiLoggy {
  final Cycle cycle;
  final int entryIndex;
  final bool editingEnabled;
  final StickerWithText? existingCorrection;
  final ChartViewModel model;

  const StickerCorrectionDialog({
    super.key,
    required this.entryIndex,
    this.existingCorrection,
    required this.cycle,
    required this.editingEnabled,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    Sticker? selectedSticker = existingCorrection?.sticker;
    String? selectedStickerText = existingCorrection?.text;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: editingEnabled ? const Text('Edit Stamp') : const Text("Correct Stamp"),
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
              if (!editingEnabled) {
                model.updateStickerCorrections(cycle.index, entryIndex, correction);
              } else {
                model.editSticker(cycle.index, entryIndex, correction);
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      );
    });
  }

  Widget _createStickerCorrectionContent(Sticker? selectedSticker, String? selectedStickerText, void Function(Sticker?) onSelectSticker, void Function(String?) onSelectText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(padding: EdgeInsets.all(10), child: Text("Select the correct sticker")),
        StickerSelectionRow(selectedSticker: selectedSticker, onSelect: onSelectSticker),
        const Padding(padding: EdgeInsets.all(10), child: Text("Select the correct text")),
        StickerTextSelectionRow(selectedText: selectedStickerText, onSelect: onSelectText, sticker: Sticker.white,),
      ],
    );
  }

}

class StickerSelectionRow extends StatelessWidget {
  final bool includeYellow;
  final Sticker? selectedSticker;
  final void Function(Sticker?) onSelect;

  const StickerSelectionRow({super.key, this.selectedSticker, required this.onSelect, this.includeYellow = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createDialogSticker(Sticker.red, selectedSticker, onSelect),
        _createDialogSticker(Sticker.green, selectedSticker, onSelect),
        _createDialogSticker(Sticker.greenBaby, selectedSticker, onSelect),
        _createDialogSticker(Sticker.whiteBaby, selectedSticker, onSelect),
        if (includeYellow) _createDialogSticker(Sticker.yellow, selectedSticker, onSelect),
        if (includeYellow) _createDialogSticker(Sticker.yellowBaby, selectedSticker, onSelect),
      ],
    );
  }
}

Widget _createDialogSticker(Sticker sticker, Sticker? selectedSticker, void Function(Sticker?) onSelect) {
  Widget child = StickerWidget(stickerWithText: StickerWithText(sticker, null), onTap: () => onSelect(sticker));
  child = Tooltip(message: sticker.name, child: child);
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

class StickerTextSelectionRow extends StatelessWidget {
  final String? selectedText;
  final Sticker sticker;
  final void Function(String?) onSelect;

  const StickerTextSelectionRow({super.key, this.selectedText, required this.onSelect, required this.sticker});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dialogTextSticker(""),
        _dialogTextSticker("P"),
        _dialogTextSticker("1"),
        _dialogTextSticker("2"),
        _dialogTextSticker("3"),
      ],
    );
  }

  Widget _dialogTextSticker(String text) {
    Widget sticker = StickerWidget(stickerWithText: StickerWithText(this.sticker, text), onTap: () => onSelect(text));
    var message = text == "" ? "No Text" : text;
    sticker = Tooltip(message: message, child: sticker);
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

class ObservationDialog extends StatelessWidget with UiLoggy {
  final Cycle cycle;
  final ChartEntry entry;
  final int entryIndex;
  final String? correction;
  final ChartViewModel model;
  final bool editEnabled;


  const ObservationDialog({
    super.key,
    required this.cycle,
    required this.entry,
    this.correction,
    required this.entryIndex,
    required this.model,
    required this.editEnabled,
  });

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var cycleIndex = cycle.index;
    return StatefulBuilder(builder: (context, setState) => AlertDialog(
      title: Text(editEnabled ? "Edit Observation" : "Correct Observation"),
      content: Form(
        key: formKey,
        child: TextFormField(
          initialValue: editEnabled ? entry.observationText : correction ?? entry.observationText,
          validator: (value) {
            if (!editEnabled && (value == null || value.isEmpty)) {
              return 'Please enter some text';
            }
            return null;
          },
          onSaved: (value) {
            if (editEnabled) {
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
        if (!editEnabled && correction != null) TextButton(
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
    ));
  }
}
