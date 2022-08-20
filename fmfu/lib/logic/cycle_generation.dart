
import 'dart:math';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/utils/distributions.dart';

abstract class Recipe {
  List<Observation> getObservations();
}

class CycleRecipe extends Recipe {
  final List<Recipe> _recipes;

  CycleRecipe(
      FlowRecipe flowRecipe,
      PreBuildUpRecipe preBuildUpRecipe,
      BuildUpRecipe buildUpRecipe,
      PostPeakRecipe postPeakRecipe)
  : _recipes = [flowRecipe, preBuildUpRecipe, buildUpRecipe, postPeakRecipe];

  @override
  List<Observation> getObservations() {
    List<Observation> observations = [];
    for (var recipe in _recipes) {
      observations.addAll(recipe.getObservations());
    }
    return observations;
  }

  static double defaultUnusualBleedingFrequency = 20;
  static double defaultMucusPatchFrequency = 20;
  static double defaultPrePeakPeakTypeFrequency = 50;
  static int defaultFlowLength = 5;
  static int defaultPreBuildupLength = 4;
  static int defaultBuildUpLength = 4;
  static int defaultPeakTypeLength = 4;
  static int defaultPostPeakLength = 12;

  static CycleRecipe standardRecipe = create(
      defaultUnusualBleedingFrequency / 100,
      defaultMucusPatchFrequency / 100,
      defaultPrePeakPeakTypeFrequency / 100,
      defaultMucusPatchFrequency / 100,
      defaultFlowLength,
      defaultPreBuildupLength,
      defaultBuildUpLength,
      defaultPeakTypeLength,
      defaultPostPeakLength,
      false);

  static CycleRecipe create(
      double unusualBleedingProbability,
      double prePeakMucusPatchProbability,
      double prePeakPeakTypeProbability,
      double postPeakMucusPatchProbability,
      int flowLength,
      int preBuildUpLength,
      int buildUpLength,
      int peakTypeLength,
      int postPeakLength,
      bool askESQ) {
    if (unusualBleedingProbability < 0 || unusualBleedingProbability > 1) {
      throw Exception("Invalid unusualBleedingProbability $unusualBleedingProbability");
    }
    if (prePeakMucusPatchProbability < 0 || prePeakMucusPatchProbability > 1) {
      throw Exception("Invalid mucusPatchProbability $prePeakMucusPatchProbability");
    }
    if (prePeakPeakTypeProbability < 0 || prePeakPeakTypeProbability > 1) {
      throw Exception("Invalid prePeakPeakTypeProbability $prePeakPeakTypeProbability");
    }
    if (postPeakMucusPatchProbability < 0 || postPeakMucusPatchProbability > 1) {
      throw Exception("Invalid mucusPatchProbability $postPeakMucusPatchProbability");
    }
    if (flowLength < 0) {
      throw Exception("Invalid flowLength $flowLength");
    }
    if (preBuildUpLength < 0) {
      throw Exception("Invalid preBuildUpLength $preBuildUpLength");
    }
    if (buildUpLength < 0) {
      throw Exception("Invalid buildUpLength $buildUpLength");
    }
    if (peakTypeLength < 0 || peakTypeLength > buildUpLength) {
      throw Exception("Invalid peakTypeLength $peakTypeLength");
    }
    if (postPeakLength < 0) {
      throw Exception("Invalid postPeakLength $postPeakLength");
    }
    return CycleRecipe(
      FlowRecipe(
          NormalDistribution(flowLength, 1),
          Flow.heavy,
          Flow.veryLight
      ),
      PreBuildUpRecipe(
        NormalDistribution(preBuildUpLength, 1),
        nonMucusDischargeGenerator,
        UniformAnomalyGenerator(
          prePeakMucusPatchProbability,
        ),
        DischargeSummaryGenerator(
          // Non-peak
          nonPeakTypeDischargeSummary, [
            AlternativeDischarge(peakTypeDischargeSummary, prePeakPeakTypeProbability),
        ],
        ),
        NormalAnomalyGenerator(
          NormalDistribution(1, 1),
          unusualBleedingProbability,
        ),
      ),
      BuildUpRecipe(
        NormalDistribution(buildUpLength, 1),
        NormalDistribution(peakTypeLength, 1),
        peakTypeDischargeGenerator,
        nonPeakTypeDischargeGenerator,
      ),
      PostPeakRecipe(
        NormalDistribution(postPeakLength, 1),
        NormalDistribution(1, 1),
        nonPeakTypeDischargeGenerator,
        nonMucusDischargeGenerator,
        NormalAnomalyGenerator(
          NormalDistribution(1, 1),
          unusualBleedingProbability,
        ),
        UniformAnomalyGenerator(postPeakMucusPatchProbability),
      ),
    );
  }

  static final nonMucusDischargeSummary = DischargeSummary(
      DischargeType.dry, DischargeFrequency.allDay, []);
  static final nonMucusDischargeGenerator = DischargeSummaryGenerator(
      nonMucusDischargeSummary, [
        AlternativeDischarge(
            DischargeSummary(DischargeType.shinyWithoutLubrication, DischargeFrequency.twice, []),
            0.5,
        )
      ]);

  static final peakTypeDischargeSummary = DischargeSummary(
      DischargeType.stretchy, DischargeFrequency.twice, [DischargeDescriptor.clear]);
  static final peakTypeDischargeGenerator = DischargeSummaryGenerator(
      peakTypeDischargeSummary,
      [
        AlternativeDischarge(
          DischargeSummary(DischargeType.tacky, DischargeFrequency.once, [DischargeDescriptor.clear]),
          0.5,
        ),
        AlternativeDischarge(
          DischargeSummary(DischargeType.stretchy, DischargeFrequency.once, [DischargeDescriptor.cloudy]),
          0.5,
        ),
      ],
  );

  static final nonPeakTypeDischargeSummary = DischargeSummary(
      DischargeType.sticky, DischargeFrequency.twice, [DischargeDescriptor.cloudy]);
  static final nonPeakTypeDischargeGenerator = DischargeSummaryGenerator(
      nonPeakTypeDischargeSummary, [
        AlternativeDischarge(
          DischargeSummary(DischargeType.tacky, DischargeFrequency.once, [DischargeDescriptor.cloudy]),
          0.5,
        )]);
}

class FlowRecipe extends Recipe {
  final NormalDistribution flowLength;
  final FlowIntensityDistribution _flowDistribution;

  FlowRecipe(this.flowLength, Flow maxFlow, Flow minFlow) :
        _flowDistribution = FlowIntensityDistribution(
            _eligibleFlows(maxFlow, minFlow), 2 + Random().nextDouble() * 3
        );

  @override
  List<Observation> getObservations() {
    List<Observation> observations = [];
    for (var flow in _flowDistribution.get(flowLength.get())) {
      DischargeSummary? dischargeSummary;
      if (flow.requiresDischargeSummary) {
        dischargeSummary = DischargeSummary(DischargeType.dry, DischargeFrequency.once, []);
      }
      observations.add(Observation(flow, dischargeSummary));
    }
    return observations;
  }

  static List<Flow> _eligibleFlows(Flow max, Flow min) {
    if (max.index > min.index) {
      throw Exception("Max ($max) cannot be greater intensity than min ($min)");
    }
    List<Flow> flows = List.of(Flow.values);
    Set<Flow> flowsToRemove = {};
    for (var flow in flows) {
      if (flow.index < max.index) {
        flowsToRemove.add(flow);
      }
      if (flow.index > min.index) {
        flowsToRemove.add(flow);
      }
    }
    for (var flow in flowsToRemove) {
      flows.remove(flow);
    }
    return flows;
  }
}

class AlternativeDischarge {
  final DischargeSummary summary;
  final double probability;

  AlternativeDischarge(this.summary, this.probability);
}

class DischargeSummaryGenerator {
  final DischargeSummary _typicalDischarge;
  final List<AlternativeDischarge> _alternatives;

  DischargeSummaryGenerator(this._typicalDischarge, this._alternatives);


  DischargeSummary get() {
    for (var alternative in List.from(_alternatives)..shuffle()) {
      if (Random().nextDouble() < alternative.probability) {
        return alternative.summary;
      }
    }
    return _typicalDischarge;
  }
}

abstract class AnomalyGenerator {
  List<bool> generate(int periodLength);
}

class UniformAnomalyGenerator extends AnomalyGenerator {
  final Random _r = Random();
  final double _probability;

  UniformAnomalyGenerator(this._probability);

  @override
  List<bool> generate(int periodLength) {
    List<bool> anomalyField = List.filled(periodLength, false);
    for (int i=0; i<anomalyField.length; i++) {
      if (_r.nextDouble() < _probability) {
        anomalyField[i] = true;
      }
    }
    return anomalyField;
  }}

class NormalAnomalyGenerator extends AnomalyGenerator {
  final Random _r = Random();
  final NormalDistribution _anomalyLength;
  final double _probability;

  NormalAnomalyGenerator(this._anomalyLength, this._probability);

  @override
  List<bool> generate(int periodLength) {
    List<bool> anomalyField = List.filled(periodLength, false);

    if (_r.nextDouble() < _probability) {
      int mucusPatchLength = _anomalyLength.get();
      int maxStartIndex = periodLength - mucusPatchLength;
      if (maxStartIndex < 0) {
        return anomalyField;
      }
      int startIndex = Random().nextInt(maxStartIndex+1);
      for (int i=startIndex; i < startIndex + mucusPatchLength; i++) {
        anomalyField[i] = true;
      }
    }
    return anomalyField;
  }
}

class PreBuildUpRecipe extends Recipe {
  final NormalDistribution _length;
  final DischargeSummaryGenerator _nonMucusDischargeGenerator;
  final AnomalyGenerator _mucusPatchGenerator;
  final DischargeSummaryGenerator _nonPeakMucusDischargeGenerator;
  final AnomalyGenerator _abnormalBleedingGenerator;

  PreBuildUpRecipe(this._length, this._nonMucusDischargeGenerator, this._mucusPatchGenerator, this._nonPeakMucusDischargeGenerator, this._abnormalBleedingGenerator);

  @override
  List<Observation> getObservations() {
    int periodLength = _length.get();
    List<bool> mucusPatchField = _mucusPatchGenerator.generate(periodLength);
    List<bool> abnormalBleedingField = _abnormalBleedingGenerator.generate(periodLength);
    List<Observation> observation = [];
    for (int i=0; i<periodLength; i++) {
      var dischargeSummary = mucusPatchField[i] ?
          _nonPeakMucusDischargeGenerator.get() : _nonMucusDischargeGenerator.get();
      var flow = abnormalBleedingField[i] ? Flow.light : null;
      observation.add(Observation(flow, dischargeSummary));
    }
    return observation;
  }
}

class BuildUpRecipe extends Recipe {
  final NormalDistribution _length;
  final NormalDistribution _peakTypeLength;
  final DischargeSummaryGenerator _peakTypeDischargeGenerator;
  final DischargeSummaryGenerator _nonPeakTypeDischargeGenerator;

  BuildUpRecipe(this._length, this._peakTypeLength, this._peakTypeDischargeGenerator, this._nonPeakTypeDischargeGenerator);

  @override
  List<Observation> getObservations() {
    List<Observation> observation = [];
    int length = _length.get();
    int nonPeakTypeLength = length - _peakTypeLength.get();
    for (int i=0; i<length; i++) {
      var dischargeSummary = observation.length < nonPeakTypeLength ?
          _nonPeakTypeDischargeGenerator.get() : _peakTypeDischargeGenerator.get();
      observation.add(Observation(null, dischargeSummary));
    }
    return observation;
  }
}

class PostPeakRecipe extends Recipe {
  final NormalDistribution _length;
  final NormalDistribution _mucusLength;
  final DischargeSummaryGenerator _nonPeakTypeMucusDischargeGenerator;
  final DischargeSummaryGenerator _nonMucusDischargeGenerator;
  final AnomalyGenerator _abnormalBleedingGenerator;
  final AnomalyGenerator _mucusPatchGenerator;

  PostPeakRecipe(this._length, this._mucusLength, this._nonPeakTypeMucusDischargeGenerator, this._nonMucusDischargeGenerator, this._abnormalBleedingGenerator, this._mucusPatchGenerator);

  @override
  List<Observation> getObservations() {
    int postPeakLength = _length.get();
    int mucusLength = _mucusLength.get();
    int nonMucusLength = postPeakLength - mucusLength;

    List<bool> abnormalBleedingField = _abnormalBleedingGenerator.generate(nonMucusLength);
    List<bool> mucusPatchField = _mucusPatchGenerator.generate(nonMucusLength);

    List<Observation> observation = [];
    for (int i=0; i<postPeakLength; i++) {
      if (i < mucusLength) {
        observation.add(Observation(null, _nonPeakTypeMucusDischargeGenerator.get()));
        continue;
      }
      var flow = abnormalBleedingField[i-mucusLength] ? Flow.light : null;
      var dischargeSummary = mucusPatchField[i-mucusLength] ?
          _nonPeakTypeMucusDischargeGenerator.get() : _nonMucusDischargeGenerator.get();
      observation.add(Observation(flow, dischargeSummary));
    }
    return observation;
  }
}

class FlowIntensityDistribution {
  static const int _distributionWidth = 12;
  final GamaDistribution _gamaDistribution;
  final List<Flow> _eligibleFlows;

  // TODO: make scale and shape random to some degree
  FlowIntensityDistribution(this._eligibleFlows, double shape) : _gamaDistribution = GamaDistribution(shape, -1/3*shape + 8/3);

  List<Flow> get(int length) {
    double stepFactor = 0.2 / (_eligibleFlows.length - 1);
    List<Flow> flow = [];
    for (int i=1; i<=length; i++) {
      double x = i * _distributionWidth / length;
      double gx = _gamaDistribution.cdf(x);
      int index = _eligibleFlows.length - 1 - (gx / stepFactor).round();
      flow.add(_eligibleFlows[index]);
    }
    return flow;
  }
}