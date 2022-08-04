
import 'dart:math';
import 'package:dart_numerics/dart_numerics.dart' as numerics;
import '../models/observation.dart';

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
      // TODO: add discharge type for L and VL days
      observations.add(Observation(flow, null));
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

  PreBuildUpRecipe(this._length);

  @override
  List<Observation> getObservations() {
    List<Observation> observation = [];
    for (int i=0; i<_length.get(); i++) {
      observation.add(Observation(null, DischargeSummary(DischargeType.dry, DischargeFrequency.allDay)));
    }
    return observation;
  }
}

class BuildUpRecipe extends Recipe {
  final NormalDistribution _length;

  BuildUpRecipe(this._length);

  @override
  List<Observation> getObservations() {
    List<Observation> observation = [];
    for (int i=0; i<_length.get(); i++) {
      observation.add(Observation(null, DischargeSummary(DischargeType.sticky, DischargeFrequency.once)));
    }
    return observation;
  }
}

class PostPeakRecipe extends Recipe {
  final NormalDistribution _length;

  PostPeakRecipe(this._length);

  @override
  List<Observation> getObservations() {
    List<Observation> observation = [];
    for (int i=0; i<_length.get(); i++) {
      observation.add(Observation(null, DischargeSummary(DischargeType.dry, DischargeFrequency.once)));
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
        cachedFactor = 1/(numerics.gamma(shape) * pow(scale, shape));

  double cdf(double x) {
    return cachedFactor * pow(x, shape - 1) * pow(numerics.e, -1 * x / scale);
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