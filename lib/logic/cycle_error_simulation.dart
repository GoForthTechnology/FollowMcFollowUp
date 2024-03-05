

import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/model/stickers.dart';

enum ErrorScenario {
  forgetD4,
  forgetObservationOnBleeding,
  forgetRedStampForUnusualBleeding,
  forgetCountOfThreeForUnusualBleeding,
}

List<ChartEntry> introduceErrors(List<ChartEntry> entries, Set<ErrorScenario> scenarios) {
  if (scenarios.contains(ErrorScenario.forgetCountOfThreeForUnusualBleeding)) {
    // If you've forgotten to put the right stamp on, you've probably also
    // forgotten to add a count of three...
    scenarios.add(ErrorScenario.forgetCountOfThreeForUnusualBleeding);
  }
  List<ChartEntry> out = [];
  for (var entry in entries) {
    out.add(ChartEntry(
      observationText: entry.renderedObservation?.observationText ?? "",
      additionalText: entry.additionalText,
      renderedObservation: entry.renderedObservation,
    ));
  }
  for (var scenario in scenarios) {
    switch (scenario) {
      case ErrorScenario.forgetD4:
        out = runForgetD4(out);
        break;
      case ErrorScenario.forgetObservationOnBleeding:
        out = runForgetObservationOnFlow(out);
        break;
      case ErrorScenario.forgetRedStampForUnusualBleeding:
        out = runForgetRedStampForUnusualBleeding(out);
        break;
      case ErrorScenario.forgetCountOfThreeForUnusualBleeding:
        out = runForgetCountOfThreeForUnusualBleeding(out);
        break;
    }
  }
  return out;
}

List<ChartEntry> runForgetCountOfThreeForUnusualBleeding(List<ChartEntry> entries) {
  List<ChartEntry> out = entries;
  for (int i = 0; i < out.length; i++) {
    final entry = entries[i];
    if (entry.renderedObservation == null) {
      continue;
    }
    var observation = entry.renderedObservation!;
    var countOfThreeReason = observation.debugInfo.countOfThreeReason;
    if (countOfThreeReason == CountOfThreeReason.unusualBleeding) {
      Sticker updatedStamp;
      if (observation.hasMucus) {
        updatedStamp = Sticker.whiteBaby;
      } else {
        updatedStamp = Sticker.green;
      }
      out[i] = ChartEntry(
        observationText: entry.observationText,
        additionalText: entry.additionalText,
        renderedObservation: entry.renderedObservation,
        manualSticker: StickerWithText(updatedStamp, null),
      );
    }
  }
  return out;
}

List<ChartEntry> runForgetRedStampForUnusualBleeding(List<ChartEntry> entries) {
  List<ChartEntry> out = entries;
  for (int i=0; i<out.length; i++) {
    final entry = entries[i];
    if (entry.renderedObservation == null) {
      continue;
    }
    var observation = entry.renderedObservation!;
    if (observation.hasBleeding && !observation.inFlow) {
      Sticker updatedStamp;
      if (observation.hasMucus) {
        updatedStamp = Sticker.whiteBaby;
      } else {
        if (observation.countOfThree > 0) {
          updatedStamp = Sticker.greenBaby;
        } else {
          updatedStamp = Sticker.green;
        }
      }
      out[i] = ChartEntry(
        observationText: entry.observationText,
        additionalText: entry.additionalText,
        renderedObservation: entry.renderedObservation,
        manualSticker: StickerWithText(updatedStamp, observation.getStickerText()),
      );
    }
  }
  return out;
}

List<ChartEntry> runForgetObservationOnFlow(List<ChartEntry> entries) {
  List<ChartEntry> out = entries;
  for (int i=0; i<out.length; i++) {
    var entry = entries[i];
    if (entry.renderedObservation?.hasBleeding ?? false) {
      String updatedObservationText = entry.observationText;
      if (entry.observationText.startsWith("L")) {
        updatedObservationText = "L";
      } else if (entry.observationText.startsWith("VL")) {
        updatedObservationText = "VL";
      } else if (entry.observationText.startsWith("B")) {
        updatedObservationText = "B";
      }
      out[i] = ChartEntry(
        observationText: updatedObservationText,
        additionalText: entry.additionalText,
        renderedObservation: entry.renderedObservation,
        manualSticker: entry.manualSticker,
      );
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
    if (!entry.renderedObservation!.hasMucus) {
      entries[i] = ChartEntry(
        observationText: entry.observationText,
        additionalText: entry.additionalText,
        renderedObservation: entry.renderedObservation,
        manualSticker: StickerWithText(
          Sticker.green, null
        ),
      );
    } else if (entry.renderedObservation!.fertilityReasons.contains(Instruction.d4)) {
      entries[i] = ChartEntry(
        observationText: entry.observationText,
        additionalText: entry.additionalText,
        renderedObservation: entry.renderedObservation,
        manualSticker: StickerWithText(
            entry.renderedObservation!.getSticker(), null
        ),
      );
    }
  }
  return out;
}