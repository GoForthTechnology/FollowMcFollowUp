
import 'dart:math';

import 'package:fmfu/utils/gamma.dart';

class UniformRange {
  final double lowerBound;
  final double upperBound;

  const UniformRange(this.lowerBound, this.upperBound);

  double get() {
    var delta = upperBound - lowerBound;
    return lowerBound + delta * Random().nextDouble();
  }
}

class NormalDistribution {
  final int _mean;
  final double _stdDev;
  final Random _r = Random();

  NormalDistribution(this._mean, this._stdDev);

  int get() {
    double u = _r.nextDouble() * 2 - 1;
    double v = _r.nextDouble() * 2 - 1;
    double r = u*u + v*v;
    if (r == 0 || r >= 1) {
      return get();
    }
    double c = sqrt(-2 * log(r) / r);
    double d = _mean + _stdDev * u * c;
    return d.round();
  }
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
