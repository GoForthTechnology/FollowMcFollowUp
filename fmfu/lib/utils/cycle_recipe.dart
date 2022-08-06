
import 'dart:math';
import '../models/observation.dart';
import 'gamma.dart';

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

  static CycleRecipe standardRecipe = CycleRecipe(
    FlowRecipe(
        NormalDistribution(5, 1),
        Flow.heavy,
        Flow.veryLight
    ),
    PreBuildUpRecipe(
      NormalDistribution(4, 1),
      nonMucusDischargeGenerator,
    ),
    BuildUpRecipe(
      NormalDistribution(4, 1),
      NormalDistribution(3, 1),
      peakTypeDischargeGenerator,
      nonPeakTypeDischargeGenerator,
    ),
    PostPeakRecipe(
      NormalDistribution(12, 1),
      NormalDistribution(1, 1),
      nonPeakTypeDischargeGenerator,
      nonMucusDischargeGenerator,
    ),
  );

  static final DischargeSummaryGenerator nonMucusDischargeGenerator = DischargeSummaryGenerator(
      DischargeSummary(DischargeType.dry, DischargeFrequency.allDay, []), [
        AlternativeDischarge(
            DischargeSummary(DischargeType.shinyWithoutLubrication, DischargeFrequency.twice, []),
            0.5,
        )
      ]);

  static final DischargeSummaryGenerator peakTypeDischargeGenerator = DischargeSummaryGenerator(
      DischargeSummary(DischargeType.stretchy, DischargeFrequency.twice, [DischargeDescriptor.clear]), [
    AlternativeDischarge(
      DischargeSummary(DischargeType.tacky, DischargeFrequency.once, [DischargeDescriptor.clear]),
      0.5,
    )
  ]);

  static final DischargeSummaryGenerator nonPeakTypeDischargeGenerator = DischargeSummaryGenerator(
      DischargeSummary(DischargeType.sticky, DischargeFrequency.twice, [DischargeDescriptor.cloudy]), [
    AlternativeDischarge(
      DischargeSummary(DischargeType.tacky, DischargeFrequency.once, [DischargeDescriptor.cloudy]),
      0.5,
    )
  ]);
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
      if (Random().nextDouble() >= alternative.probability) {
        return alternative.summary;
      }
    }
    return _typicalDischarge;
  }
}

class PreBuildUpRecipe extends Recipe {
  final NormalDistribution _length;
  final DischargeSummaryGenerator _dischargeSummaryGenerator;

  PreBuildUpRecipe(this._length, this._dischargeSummaryGenerator);

  @override
  List<Observation> getObservations() {
    List<Observation> observation = [];
    for (int i=0; i<_length.get(); i++) {
      observation.add(Observation(null, _dischargeSummaryGenerator.get()));
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

  PostPeakRecipe(this._length, this._mucusLength, this._nonPeakTypeMucusDischargeGenerator, this._nonMucusDischargeGenerator);

  @override
  List<Observation> getObservations() {
    List<Observation> observation = [];
    int mucusLength = _mucusLength.get();
    for (int i=0; i<_length.get(); i++) {
      var dischargeSummary = observation.length < mucusLength ?
          _nonPeakTypeMucusDischargeGenerator.get() : _nonMucusDischargeGenerator.get();
      observation.add(Observation(null, dischargeSummary));
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

class GamaDistribution {
  final double shape;
  final double scale;
  final double cachedFactor;

  GamaDistribution(this.shape, this.scale) :
        cachedFactor = 1/(gamma(shape) * pow(scale, shape));

  double cdf(double x) {
    return cachedFactor * pow(x, shape - 1) * pow(e, -1 * x / scale);
  }
}

class NormalDistribution {
  final int mean;
  final double stdDev;
  final Random _r = Random();

  NormalDistribution(this.mean, this.stdDev);

  int get() {
    double u = _r.nextDouble() * 2 - 1;
    double v = _r.nextDouble() * 2 - 1;
    double r = u*u + v*v;
    if (r == 0 || r >= 1) {
      return get();
    }
    double c = sqrt(-2 * log(r) / r);
    double d = mean + stdDev * u * c;
    return d.round();
  }
}