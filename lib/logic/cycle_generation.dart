
import 'dart:math';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/utils/distributions.dart';

abstract class Recipe {
  List<Observation> getObservations({bool askESQ = false});
}

abstract class PostProcessor {
  void process(List<Observation> observations);
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
  List<Observation> getObservations({bool askESQ = false}) {
    List<Observation> observations = [];
    for (var recipe in _recipes) {
      observations.addAll(recipe.getObservations(askESQ: askESQ));
    }
    for (var processor in [ESQPostProcessor()]) {
      processor.process(observations);
    }
    return observations;
  }

  static const double defaultUnusualBleedingFrequency = 0;
  static const double defaultMucusPatchFrequency = 0;
  static const double defaultPrePeakPeakTypeFrequency = 0;
  static const int defaultFlowLength = 5;
  static const int defaultPreBuildupLength = 4;
  static const int defaultBuildUpLength = 4;
  static const int defaultPeakTypeLength = 4;
  static const int defaultPostPeakLength = 12;

  static const int defaultCycleLength = defaultFlowLength + defaultPreBuildupLength + defaultBuildUpLength + defaultPeakTypeLength + defaultPostPeakLength;

  static CycleRecipe standardRecipe = create();

  static CycleRecipe create({
    double unusualBleedingProbability = defaultUnusualBleedingFrequency / 100,
    double prePeakMucusPatchProbability = defaultMucusPatchFrequency / 100,
    double prePeakPeakTypeProbability = defaultPrePeakPeakTypeFrequency / 100,
    double postPeakMucusPatchProbability = defaultMucusPatchFrequency / 100,
    int flowLength = defaultFlowLength,
    int preBuildUpLength = defaultPreBuildupLength,
    int buildUpLength = defaultBuildUpLength,
    int peakTypeLength = defaultPeakTypeLength,
    int postPeakLength = defaultPostPeakLength,
    int preMenstrualSpottingLength = 0,
    bool postPeakPasty = false,
    bool askESQ = false,
    double stdDev = 1}) {
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
    final preBuildupDischargeGenerator = DischargeSummaryGenerator(
      nonMucusDischargeSummary, [
        AlternativeDischarge(
            postPeakPasty ? pastyCloudyDischargeSummary : nonPeakTypeDischargeSummary,
            prePeakMucusPatchProbability),
        AlternativeDischarge(peakTypeDischargeSummary, prePeakPeakTypeProbability),
      ],
    );
    final unusualBleedingGenerator = NormalAnomalyGenerator(
      lengthDist: NormalDistribution(1, stdDev),
      probability: unusualBleedingProbability,
    );

    final flowRecipe = FlowRecipe(
      NormalDistribution(flowLength, stdDev),
      Flow.heavy,
      Flow.veryLight,
      preBuildupDischargeGenerator,
    );

    final preBuildUpRecipe = PreBuildUpRecipe(
      NormalDistribution(preBuildUpLength, stdDev),
      nonMucusDischargeGenerator,
      UniformAnomalyGenerator(
        prePeakMucusPatchProbability,
      ),
      preBuildupDischargeGenerator,
      unusualBleedingGenerator,
    );

    final buildUpRecipe = BuildUpRecipe(
      NormalDistribution(buildUpLength, stdDev),
      NormalDistribution(peakTypeLength, stdDev),
      peakTypeDischargeGenerator,
      nonPeakTypeDischargeGenerator,
    );

    final postPeakRecipe = PostPeakRecipe(
      lengthDist: NormalDistribution(postPeakLength, stdDev),
      mucusLengthDist: NormalDistribution(1, stdDev),
      preMenstrualSpottingLengthDist: NormalDistribution(3, stdDev),
      mucusDischargeGenerator: postPeakPasty
          ? pastyCloudyDischargeGenerator : nonPeakTypeDischargeGenerator,
      nonMucusDischargeGenerator: postPeakPasty
          ? pastyCloudyDischargeGenerator : nonMucusDischargeGenerator,
      abnormalBleedingGenerator: unusualBleedingGenerator,
      mucusPatchGenerator: UniformAnomalyGenerator(
        postPeakMucusPatchProbability,
      ),
    );

    return CycleRecipe(flowRecipe, preBuildUpRecipe, buildUpRecipe, postPeakRecipe);
  }

  static final nonMucusDischargeSummary = DischargeSummary(
      dischargeType: DischargeType.dry,
      dischargeFrequency: DischargeFrequency.allDay,
  );
  static final nonMucusDischargeGenerator = DischargeSummaryGenerator(
      nonMucusDischargeSummary, [
        AlternativeDischarge(
            DischargeSummary(
                dischargeType: DischargeType.shinyWithoutLubrication,
                dischargeFrequency: DischargeFrequency.twice,
            ),
            0.5,
        )
      ]);

  static final peakTypeDischargeSummary = DischargeSummary(
      dischargeType: DischargeType.stretchy,
      dischargeFrequency: DischargeFrequency.twice,
      dischargeDescriptors: [DischargeDescriptor.clear],
  );
  static final peakTypeDischargeGenerator = DischargeSummaryGenerator(
      peakTypeDischargeSummary,
      [
        AlternativeDischarge(
          DischargeSummary(
              dischargeType: DischargeType.tacky,
              dischargeFrequency: DischargeFrequency.once,
              dischargeDescriptors: [DischargeDescriptor.clear],
          ),
          0.5,
        ),
        AlternativeDischarge(
          DischargeSummary(
              dischargeType: DischargeType.stretchy,
              dischargeFrequency: DischargeFrequency.once,
              dischargeDescriptors: [DischargeDescriptor.cloudy],
          ),
          0.5,
        ),
      ],
  );

  static final nonPeakTypeDischargeSummary = DischargeSummary(
      dischargeType: DischargeType.sticky,
      dischargeFrequency: DischargeFrequency.twice,
      dischargeDescriptors: [DischargeDescriptor.cloudy],
  );
  static final nonPeakTypeDischargeGenerator = DischargeSummaryGenerator(
      nonPeakTypeDischargeSummary, [
        AlternativeDischarge(
          DischargeSummary(
              dischargeType: DischargeType.tacky,
              dischargeFrequency: DischargeFrequency.once,
              dischargeDescriptors: [DischargeDescriptor.cloudy],
          ),
          0.5,
        )]);
  static final pastyCloudyDischargeSummary = DischargeSummary(
    dischargeType: DischargeType.sticky,
    dischargeFrequency: DischargeFrequency.twice,
    dischargeDescriptors: [DischargeDescriptor.pasty, DischargeDescriptor.cloudy],
  );
  static final pastyCloudyDischargeGenerator = DischargeSummaryGenerator(
      pastyCloudyDischargeSummary, []);
}

class ESQPostProcessor extends PostProcessor {
  @override
  void process(List<Observation> observations) {
    for (int i=0; i<observations.length; i++) {
      var observation = observations[i];
      if (observation.essentiallyTheSame == null) {
        continue;
      }
      observations[i] = Observation(
          flow: observation.flow,
          dischargeSummary: observation.dischargeSummary,
          essentiallyTheSame: null,
      );
      break;
    }
  }
}

class FlowRecipe extends Recipe {
  final NormalDistribution flowLength;
  final FlowIntensityDistribution _flowDistribution;
  final DischargeSummaryGenerator _dischargeSummaryGenerator;

  FlowRecipe(this.flowLength, Flow maxFlow, Flow minFlow, this._dischargeSummaryGenerator) :
        _flowDistribution = FlowIntensityDistribution(
            _eligibleFlows(maxFlow, minFlow), 2 + Random().nextDouble() * 3
        );

  @override
  List<Observation> getObservations({bool askESQ = false}) {
    List<Observation> observations = [];
    for (var flow in _flowDistribution.get(flowLength.get())) {
      DischargeSummary? dischargeSummary;
      if (flow.requiresDischargeSummary) {
        dischargeSummary = _dischargeSummaryGenerator.get();
      }
      bool hasMucus = dischargeSummary?.hasMucus ?? false;
      bool? essentiallyTheSame = askESQ && hasMucus ? true : null;
      observations.add(Observation(
          flow: flow,
          dischargeSummary: dischargeSummary,
          essentiallyTheSame: essentiallyTheSame,
      ));
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

class PreBuildUpRecipe extends Recipe {
  final NormalDistribution _length;
  final DischargeSummaryGenerator _nonMucusDischargeGenerator;
  final AnomalyGenerator _mucusPatchGenerator;
  final DischargeSummaryGenerator _nonPeakMucusDischargeGenerator;
  final AnomalyGenerator _abnormalBleedingGenerator;

  PreBuildUpRecipe(this._length, this._nonMucusDischargeGenerator, this._mucusPatchGenerator, this._nonPeakMucusDischargeGenerator, this._abnormalBleedingGenerator);

  @override
  List<Observation> getObservations({bool askESQ = false}) {
    int periodLength = _length.get();
    List<bool> mucusPatchField = _mucusPatchGenerator.generate(periodLength);
    List<bool> abnormalBleedingField = _abnormalBleedingGenerator.generate(periodLength);
    List<Observation> observation = [];
    for (int i=0; i<periodLength; i++) {
      var dischargeSummary = mucusPatchField[i] ?
          _nonPeakMucusDischargeGenerator.get() : _nonMucusDischargeGenerator.get();
      var flow = abnormalBleedingField[i] ? Flow.light : null;
      var essentiallyTheSame = dischargeSummary.hasMucus && askESQ ? true : null;
      observation.add(Observation(
          flow: flow,
          dischargeSummary: dischargeSummary,
          essentiallyTheSame: essentiallyTheSame,
      ));
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
  List<Observation> getObservations({bool askESQ = false}) {
    List<Observation> observation = [];
    int length = _length.get();
    int nonPeakTypeLength = length - _peakTypeLength.get();
    for (int i=0; i<length; i++) {
      var dischargeSummary = observation.length < nonPeakTypeLength ?
          _nonPeakTypeDischargeGenerator.get() : _peakTypeDischargeGenerator.get();
      observation.add(Observation(
          dischargeSummary: dischargeSummary,
          essentiallyTheSame: askESQ ? false : null,
      ));
    }
    return observation;
  }
}

class PostPeakRecipe extends Recipe {
  final NormalDistribution lengthDist;
  final NormalDistribution mucusLengthDist;
  final DischargeSummaryGenerator mucusDischargeGenerator;
  final DischargeSummaryGenerator nonMucusDischargeGenerator;
  final AnomalyGenerator abnormalBleedingGenerator;
  final AnomalyGenerator mucusPatchGenerator;
  final NormalDistribution preMenstrualSpottingLengthDist;

  PostPeakRecipe({
    required this.lengthDist,
    required this.mucusLengthDist,
    required this.mucusDischargeGenerator,
    required this.nonMucusDischargeGenerator,
    required this.abnormalBleedingGenerator,
    required this.mucusPatchGenerator,
    required this.preMenstrualSpottingLengthDist,
  });

  @override
  List<Observation> getObservations({bool askESQ = false}) {
    int postPeakLength = lengthDist.get();
    int mucusLength = mucusLengthDist.get();
    int nonMucusLength = postPeakLength - mucusLength;
    int preMenstrualSpottingLength = preMenstrualSpottingLengthDist.get();
    int startOfPreMenstrualSpotting = postPeakLength - preMenstrualSpottingLength;

    List<bool> abnormalBleedingField = abnormalBleedingGenerator.generate(nonMucusLength);
    List<bool> mucusPatchField = mucusPatchGenerator.generate(nonMucusLength);

    List<Observation> observation = [];
    for (int i=0; i<postPeakLength; i++) {
      if (i >= startOfPreMenstrualSpotting) {
        observation.add(Observation(
          flow: Flow.veryLight,
          dischargeSummary: DischargeSummary(
            dischargeType: DischargeType.dry,
            dischargeFrequency: DischargeFrequency.allDay,
          ),
        ));
        continue;
      }
      if (i < mucusLength) {
        observation.add(Observation(dischargeSummary: mucusDischargeGenerator.get()));
        continue;
      }
      var flow = abnormalBleedingField[i-mucusLength] ? Flow.light : null;
      var dischargeSummary = mucusPatchField[i-mucusLength] ?
          mucusDischargeGenerator.get() : nonMucusDischargeGenerator.get();
      observation.add(Observation(
          flow: flow,
          dischargeSummary: dischargeSummary,
      ));
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
  final NormalDistribution lengthDist;
  final double probability;

  NormalAnomalyGenerator({required this.lengthDist, required this.probability});

  @override
  List<bool> generate(int periodLength) {
    List<bool> anomalyField = List.filled(periodLength, false);

    if (_r.nextDouble() < probability) {
      int mucusPatchLength = lengthDist.get();
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

class AlternativeDischarge {
  final DischargeSummary summary;
  final double probability;

  AlternativeDischarge(this.summary, this.probability);
}
