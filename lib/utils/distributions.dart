
import 'dart:math';

import 'package:fmfu/utils/gamma.dart';
import 'package:json_annotation/json_annotation.dart';

part 'distributions.g.dart';

class UniformRange {
  final double lowerBound;
  final double upperBound;

  const UniformRange(this.lowerBound, this.upperBound);

  double get() {
    var delta = upperBound - lowerBound;
    return lowerBound + delta * Random().nextDouble();
  }
}

@JsonSerializable(explicitToJson: true)
class NormalDistribution {
  final int mean;
  final double stdDev;
  final Random _r = Random();

  NormalDistribution(this.mean, this.stdDev);

  int get() {
    if (mean == 0) {
      return 0;
    }
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

  factory NormalDistribution.fromJson(Map<String, dynamic> json) => _$NormalDistributionFromJson(json);
  Map<String, dynamic> toJson() => _$NormalDistributionToJson(this);
}

class GamaDistribution {
  final double _shape;
  final double _scale;
  final double _cachedFactor;

  GamaDistribution(this._shape, this._scale) :
        _cachedFactor = 1/(gamma(_shape) * pow(_scale, _shape));

  double cdf(double x) {
    return _cachedFactor * pow(x, _shape - 1) * pow(e, -1 * x / _scale);
  }
}
