

import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/stickers.dart';

enum ErrorScenario {
  forgetD4,
  forgetObservationOnFlow,
}

List<ChartEntry> introduceErrors(List<ChartEntry> entries, List<ErrorScenario> scenarios) {
  print("FOO ${scenarios.length}");
  List<ChartEntry> out = [];
  for (var entry in entries) {
    out.add(ChartEntry(
      observationText: entry.renderedObservation?.observationText ?? "",
      renderedObservation: entry.renderedObservation,
    ));
  }
  for (var scenario in scenarios) {
    switch (scenario) {
      case ErrorScenario.forgetD4:
        out = runForgetD4(out);
        break;
      case ErrorScenario.forgetObservationOnFlow:
        out = runForgetObservationOnFlow(out);
        break;
    }
  }
  return out;
}

List<ChartEntry> runForgetObservationOnFlow(List<ChartEntry> entries) {
  List<ChartEntry> out = entries;
  for (int i=0; i<out.length; i++) {
    var entry = entries[i];
    if (entry.renderedObservation?.inFlow ?? false) {
      String updatedObservationText = entry.observationText;
      if (entry.observationText.startsWith("L")) {
        updatedObservationText = "L";
      } else if (entry.observationText.startsWith("VL")) {
        updatedObservationText = "VL";
      } else if (entry.observationText.startsWith("B")) {
        updatedObservationText = "B";
      }
      out[i] = ChartEntry(observationText: updatedObservationText, renderedObservation: entry.renderedObservation, manualSticker: entry.manualSticker);
    }
  }
  return out;
}

List<ChartEntry> runForgetD4(List<ChartEntry> entries) {
  List<ChartEntry> out = entries;
  int d4Index = -1;
  for (int i=0; i<entries.length; i++) {
    if (entries[i].renderedObservation!.fertilityReasons.contains(Instruction.d4)) {
      d4Index = i;
      break;
    }
  }
  if (d4Index < 0) {
    return out;
  }
  for (int i=d4Index; i<=d4Index+3; i++) {
    var entry = entries[i];
    int count = i-d4Index;
    if (!entry.renderedObservation!.hasMucus) {
      entries[i] = ChartEntry(
        observationText: entry.observationText,
        renderedObservation: entry.renderedObservation,
        manualSticker: StickerWithText(
          Sticker.green, null
        ),
      );
    } else if (entry.renderedObservation!.fertilityReasons.contains(Instruction.d4)) {
      entries[i] = ChartEntry(
        observationText: entry.observationText,
        renderedObservation: entry.renderedObservation,
        manualSticker: StickerWithText(
            entry.renderedObservation!.getSticker(), null
        ),
      );
    }
  }
  return out;
}