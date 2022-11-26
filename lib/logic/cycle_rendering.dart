
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/model/rendered_observation.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:time_machine/time_machine.dart';

List<RenderedObservation> renderObservations(List<Observation> observations, LocalDate? startOfPrePeakYellowStamps, LocalDate? startOfPostPeak, {LocalDate? startDate}) {
  int daysOfFlow = 0;
  int daysOfMucus = 0;
  int consecutiveDaysOfNonPeakMucus = 0;
  int consecutiveDaysOfPeakMucus = 0;
  CountsOfThree countsOfThree = CountsOfThree();
  //bool yesterdayWasEssentiallyTheSame = false;
  LocalDate? currentDate = startDate;
  bool inEssentialSamenessPattern = true;
  List<int> pointsOfChange = [];

  List<RenderedObservation> renderedObservations = [];
  for (int i=0; i < observations.length; i++) {
    var observation = observations[i];
    var isPostPeak = countsOfThree.getCount(CountOfThreeReason.peakDay, i) > 0;

    if (observation.hasMucus) {
      daysOfMucus++;
    }
    bool prePeakYellowEnabled = startOfPrePeakYellowStamps != null && (
      currentDate == null || currentDate >= startOfPrePeakYellowStamps
    );
    bool postPeakYellowEnabled = startOfPostPeak != null && (
        currentDate == null || currentDate >= startOfPostPeak
    );
    bool canAskESQ = prePeakYellowEnabled;
    var shouldAskESQ = canAskESQ && daysOfMucus > 1 && !(countsOfThree.getCount(CountOfThreeReason.peakDay, i) > 3);
    var isPointOfChange = shouldAskESQ && /*yesterdayWasEssentiallyTheSame &&*/ !(observation.essentiallyTheSame ?? false);
    if (isPointOfChange) {
      pointsOfChange.add(i);
      inEssentialSamenessPattern = !inEssentialSamenessPattern;
    }
    if (observation.flow != null) {
      daysOfFlow++;
    }
    bool inFlow = daysOfFlow == i+1;
    bool hasUnusualBleeding = observation.hasBleeding && !inFlow;
    if (hasUnusualBleeding) {
      countsOfThree.registerCountStart(CountOfThreeReason.unusualBleeding, i);
    }

    if (observation.hasPeakTypeMucus) {
      consecutiveDaysOfPeakMucus++;
    } else {
      consecutiveDaysOfPeakMucus = 0;
    }
    if (observation.hasNonPeakTypeMucus) {
      consecutiveDaysOfNonPeakMucus++;
    } else {
      if (!observation.hasMucus && !isPostPeak && consecutiveDaysOfNonPeakMucus >= 3) {
        countsOfThree.registerCountStart(CountOfThreeReason.consecutiveDaysOfNonPeakMucus, i - 1);
      }
      consecutiveDaysOfNonPeakMucus = 0;
    }

    if (observation.hasPeakTypeMucus) {
      countsOfThree.registerCountStart(CountOfThreeReason.singleDayOfPeakMucus, i);
    }

    List<Instruction> fertilityReasons = [];
    if (inFlow) {
      fertilityReasons.add(Instruction.d1);
    }
    // NOTE: This should really check !isPostPeak && observation.hasMucus but...
    if (observation.hasMucus || countsOfThree.inCountOfThree(CountOfThreeReason.peakDay, i)) {
      fertilityReasons.add(Instruction.d2);
    }
    if (!isPostPeak && (consecutiveDaysOfNonPeakMucus > 0 && consecutiveDaysOfNonPeakMucus < 3)) {
      fertilityReasons.add(Instruction.d3);
    }
    if (!isPostPeak && (
        consecutiveDaysOfNonPeakMucus >= 3
        || countsOfThree.inCountOfThree(CountOfThreeReason.consecutiveDaysOfNonPeakMucus, i))) {
      fertilityReasons.add(Instruction.d4);
    }
    if (!isPostPeak && observation.hasPeakTypeMucus) {
      fertilityReasons.add(Instruction.d5);
    }
    if (hasUnusualBleeding || countsOfThree.inCountOfThree(CountOfThreeReason.unusualBleeding, i)) {
      fertilityReasons.add(Instruction.d6);
    }

    bool hasAnotherEntry = i+1 < observations.length;
    bool isPeakDay = !isPointOfChange && hasAnotherEntry && (consecutiveDaysOfPeakMucus > 0 && !observations[i+1].hasPeakTypeMucus);
    if (isPeakDay) {
      countsOfThree.registerCountStart(CountOfThreeReason.peakDay, i);
    }

    List<Instruction> infertilityReasons = [];
    if (postPeakYellowEnabled && isPostPeak) {
      infertilityReasons.add(Instruction.k2);
      // I REALLY don't like how this is done...
      if (!countsOfThree.inCountOfThree(CountOfThreeReason.peakDay, i)) {
        fertilityReasons.remove(Instruction.d2);
      }
    }
    if (prePeakYellowEnabled && !isPostPeak && inEssentialSamenessPattern) {
      infertilityReasons.add(Instruction.k1);
      fertilityReasons.remove(Instruction.d2);
      fertilityReasons.remove(Instruction.d3);
      fertilityReasons.remove(Instruction.d4);
      fertilityReasons.remove(Instruction.d5);
      countsOfThree.clearCount(CountOfThreeReason.peakDay);
      countsOfThree.clearCount(CountOfThreeReason.consecutiveDaysOfNonPeakMucus);
      countsOfThree.clearCount(CountOfThreeReason.singleDayOfPeakMucus);
    }

    var activeCountOfThreeReason = countsOfThree.getActiveReason(i);
    if (activeCountOfThreeReason == CountOfThreeReason.singleDayOfPeakMucus) {
      fertilityReasons.add(Instruction.d5);
    }
    var activeCount = countsOfThree.getCount(activeCountOfThreeReason, i);

    if (pointsOfChange.length > 1 && inEssentialSamenessPattern) {
      var lastPoCToward = pointsOfChange[pointsOfChange.length - 2];
      var pocCount = i - lastPoCToward;
      if (pocCount < 4) {
        fertilityReasons.add(Instruction.ys1c);
        activeCount = pocCount;
        activeCountOfThreeReason = CountOfThreeReason.pointOfChange;
      }
    }

    renderedObservations.add(RenderedObservation(
        observation.toString(),
        activeCount,
        isPeakDay,
        observation.hasBleeding,
        observation.hasMucus,
        inFlow,
        fertilityReasons,
        infertilityReasons,
        observation.essentiallyTheSame,
        DebugInfo(
          countOfThreeReason: activeCountOfThreeReason,
        ),
        currentDate,
    ));

    //yesterdayWasEssentiallyTheSame = observation.essentiallyTheSame ?? false;
    if (currentDate != null) {
      currentDate = currentDate.addDays(1);
    }
  }
  return renderedObservations;
}

class CountsOfThree {
  final Map<CountOfThreeReason, int> _countStarts = {};

  void registerCountStart(CountOfThreeReason reason, int i) {
    _countStarts[reason] = i;
  }

  void clearCount(CountOfThreeReason reason) {
    _countStarts.remove(reason);
  }

  CountOfThreeReason? getActiveReason(int i) {
    int minCount = 4;
    CountOfThreeReason? reason;
    _countStarts.forEach((key, index) {
      var count = i - index;
      if (count > 0 && count < minCount) {
        minCount = count;
        reason = key;
      }
    });
    return reason;
  }

  int getCount(CountOfThreeReason? reason, int i) {
    int? countStart = _countStarts[reason];
    if (countStart == null) {
      return 0;
    }
    return i - countStart;
  }

  bool inCountOfThree(CountOfThreeReason reason, int i) {
    int count = getCount(reason, i);
    return count > 0 && count <= 3;
  }
}
