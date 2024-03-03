
import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/utils/distributions.dart';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/utils/non_negative_integer.dart';

import '../logic/cycle_error_simulation.dart';

class RecipeControlViewModel extends ChangeNotifier {
  final FlowModel flowModel = FlowModel(dryDischargeRecipe);
  final PreBuildUpModel preBuildUpModel = PreBuildUpModel(dryDischargeRecipe);
  final BuildUpModel buildUpModel = BuildUpModel(nonPeakTypeDischargeRecipe, peakTypeDischargeRecipe);
  final PostPeakModel postPeakModel = PostPeakModel(dryDischargeRecipe, nonPeakTypeDischargeRecipe);

  int _templateIndex = 0;

  final List<BaseModel> _models = [];

  var _unusualBleedingProbability = 0.0;
  final NonNegativeInteger preMenstrualSpottingLength = NonNegativeInteger(0);

  final Map<ErrorScenario, double> errorScenarios = {};

  RecipeControlViewModel() {
    _models.addAll([flowModel, preBuildUpModel, buildUpModel, postPeakModel]);
    for (var notifier in [preMenstrualSpottingLength, ..._models]) {
      notifier.addListener(forwardNotification);
    }
  }

  void updateErrorScenario(ErrorScenario scenario, double? value) {
    errorScenarios[scenario] = value ?? 0;
    notifyListeners();
  }

  int templateIndex() {
    return _templateIndex;
  }

  void updateTemplateIndex(int value) {
    _templateIndex = value;
    notifyListeners();
  }

  bool _preempt = false;

  void forwardNotification() {
    if (!_preempt) {
      notifyListeners();
    }
  }

  void applyTemplate(CycleRecipe recipe, {bool notify = true}) {
    _preempt = true;
    for (var model in _models) {
      model.applyTemplate(recipe);
    }
    _unusualBleedingProbability = recipe.preBuildUpRecipe.abnormalBleedingGenerator.probability;
    preMenstrualSpottingLength.set(recipe.postPeakRecipe.preMenstrualSpottingLengthDist.mean);
    _preempt = false;
    if (notify) notifyListeners();
  }

  double unusualBleedingProbability() {
    return _unusualBleedingProbability;
  }

  void updateUnusualBleedingProbability(double value) {
    _unusualBleedingProbability = value;
    notifyListeners();
  }

  CycleRecipe getRecipe() {
    final unusualBleedingGenerator = RandomAnomalyGenerator(_unusualBleedingProbability);

    var flowRecipe = FlowRecipe(
      NormalDistribution(flowModel.length.get(), 1),
      flowModel.maxFlow(),
      flowModel.minFlow(),
      flowModel.dischargeModel.asGenerator(),
    );

    final preBuildUpRecipe = PreBuildUpRecipe(
      NormalDistribution(preBuildUpModel.length.get(), 1),
      preBuildUpModel.dischargeModel.asGenerator(),
      unusualBleedingGenerator,
    );

    final buildUpRecipe = BuildUpRecipe(
      NormalDistribution(buildUpModel.length.get(), 1),
      NormalDistribution(buildUpModel.peakTypeLength.get(), 2),
      buildUpModel.peakTypeDischargeModel.asGenerator(),
      buildUpModel.dischargeModel.asGenerator(),
    );

    final postPeakRecipe = PostPeakRecipe(
      lengthDist: NormalDistribution(postPeakModel.length.get(), 1),
      mucusLengthDist: NormalDistribution(postPeakModel.mucusLength.get(), 1),
      mucusDischargeGenerator: postPeakModel.mucusDischargeModel.asGenerator(),
      nonMucusDischargeGenerator: postPeakModel.dischargeModel.asGenerator(),
      abnormalBleedingGenerator: unusualBleedingGenerator,
      preMenstrualSpottingLengthDist: NormalDistribution(preMenstrualSpottingLength.get(), 1),
    );

    return CycleRecipe(flowRecipe, preBuildUpRecipe, buildUpRecipe, postPeakRecipe);
  }

}

class FlowModel extends BaseModel {
  var _maxFlow = Flow.heavy;
  var _minFlow = Flow.veryLight;

  FlowModel(super.defaultDischargeRecipe) : super(length: 4) {
    dischargeModel.addListener(() => notifyListeners());
  }
  
  @override
  void applyTemplate(CycleRecipe recipe) {
    setMinFlow(recipe.flowRecipe.minFlow);
    setMaxFlow(recipe.flowRecipe.maxFlow);
    length.set(recipe.flowRecipe.flowLength.mean);
    dischargeModel.fromGenerator(recipe.flowRecipe.dischargeSummaryGenerator);
  }

  Flow minFlow() {
    return _minFlow;
  }

  void setMinFlow(Flow flow) {
    _minFlow = flow;
    notifyListeners();
  }

  Flow maxFlow() {
    return _maxFlow;
  }

  void setMaxFlow(Flow flow) {
    _maxFlow = flow;
    notifyListeners();
  }
}

class PreBuildUpModel extends BaseModel {
  PreBuildUpModel(super.defaultDischargeRecipe) : super(length: 4);

  @override
  void applyTemplate(CycleRecipe recipe) {
    length.set(recipe.preBuildUpRecipe.length.mean);
    dischargeModel.fromGenerator(recipe.preBuildUpRecipe.nonMucusDischargeGenerator);
  }
}

class BuildUpModel extends BaseModel {
  final NonNegativeInteger peakTypeLength = NonNegativeInteger(3);
  final DischargeModel peakTypeDischargeModel;

  BuildUpModel(super.defaultDischargeRecipe, DischargeRecipe peakTypeDischargeRecipe)
      : peakTypeDischargeModel = DischargeModel(peakTypeDischargeRecipe), super(length: 6) {
    peakTypeLength.addListener(() => notifyListeners());
    peakTypeDischargeModel.addListener(() => notifyListeners());
  }

  @override
  void applyTemplate(CycleRecipe recipe) {
    length.set(recipe.buildUpRecipe.lengthDist.mean);
    dischargeModel.fromGenerator(recipe.buildUpRecipe.nonPeakTypeDischargeGenerator);

    peakTypeLength.set(recipe.buildUpRecipe.peakTypeLengthDist.mean);
    peakTypeDischargeModel.fromGenerator(recipe.buildUpRecipe.peakTypeDischargeGenerator);
  }
}

class PostPeakModel extends BaseModel {
  final NonNegativeInteger mucusLength = NonNegativeInteger(1);
  final DischargeModel mucusDischargeModel;

  PostPeakModel(super.defaultDischargeRecipe, DischargeRecipe mucusDischargeRecipe)
      : mucusDischargeModel = DischargeModel(mucusDischargeRecipe), super(length: 12) {
    mucusLength.addListener(() => notifyListeners());
    mucusDischargeModel.addListener(() => notifyListeners());
  }

  @override
  void applyTemplate(CycleRecipe recipe) {
    length.set(recipe.postPeakRecipe.lengthDist.mean);
    dischargeModel.fromGenerator(recipe.postPeakRecipe.nonMucusDischargeGenerator);

    mucusLength.set(recipe.postPeakRecipe.mucusLengthDist.mean);
    mucusDischargeModel.fromGenerator(recipe.postPeakRecipe.mucusDischargeGenerator);
  }
}

abstract class BaseModel extends ChangeNotifier {
  final NonNegativeInteger length;
  final DischargeModel dischargeModel;

  BaseModel(DischargeRecipe defaultDischargeRecipe, {
    required int length,
  }) : length = NonNegativeInteger(length), dischargeModel = DischargeModel(defaultDischargeRecipe) {
    this.length.addListener(() => notifyListeners());
    dischargeModel.addListener(() => notifyListeners());
  }

  void applyTemplate(CycleRecipe recipe);
}

class DischargeInterface extends ChangeNotifier {
  DischargeRecipe _recipe;

  DischargeInterface(this._recipe);

  DischargeRecipe getRecipe() {
    return _recipe;
  }

  void setRecipe(DischargeRecipe recipe) {
    _recipe = recipe;
    notifyListeners();
  }
}

class DischargeModel extends ChangeNotifier {
  DischargeInterface defaultDischarge;
  final List<AdditionalDischargeRecipe> _additionalRecipes = [];

  DischargeModel(DischargeRecipe defaultRecipe)
  : defaultDischarge = DischargeInterface(defaultRecipe) {
    defaultDischarge.addListener(() => notifyListeners());
  }

  void fromGenerator(DischargeSummaryGenerator generator) {
    removeAllAdditionalRecipes();
    defaultDischarge.setRecipe(generator.typicalDischarge);
    for (var a in generator.alternatives) {
      addAdditionalRecipe(a.generator.typicalDischarge, a.probability);
    }
  }

  DischargeSummaryGenerator asGenerator() {
    return DischargeSummaryGenerator(
      defaultDischarge.getRecipe(),
      alternatives: _additionalRecipes.map((r) => AlternativeDischargeSummaryGenerator(
        DischargeSummaryGenerator(r.recipe.defaultDischarge.getRecipe()),
        probability: r.probability,
      )).toList(),
    );
  }

  void addAdditionalRecipe(DischargeRecipe recipe, double probability) {
    _additionalRecipes.add(AdditionalDischargeRecipe(DischargeModel(recipe), probability));
    notifyListeners();
  }

  void updateAdditionalRecipe(int index, DischargeRecipe recipe, double probability) {
    _additionalRecipes[index] = AdditionalDischargeRecipe(DischargeModel(recipe), probability);
    notifyListeners();
  }

  void removeAllAdditionalRecipes() {
    _additionalRecipes.clear();
    notifyListeners();
  }

  void removeAdditionalRecipe(int index) {
    _additionalRecipes.removeAt(index);
    notifyListeners();
  }

  List<AdditionalDischargeRecipe> additionalRecipes() {
    return _additionalRecipes;
  }
}

class AdditionalDischargeRecipe {
  final DischargeModel recipe;
  final double probability;

  AdditionalDischargeRecipe(this.recipe, this.probability);
}

final dryDischargeRecipe = DischargeRecipe(
  dischargeType: DischargeType.dry,
  dischargeFrequencies: {DischargeFrequency.allDay},
);

final nonPeakTypeDischargeRecipe = DischargeRecipe(
  dischargeType: DischargeType.sticky,
  dischargeFrequencies: {DischargeFrequency.twice},
  dischargeDescriptors: {DischargeDescriptor.cloudy},
);
final peakTypeDischargeRecipe = DischargeRecipe(
  dischargeType: DischargeType.stretchy,
  dischargeFrequencies: {DischargeFrequency.twice},
  dischargeDescriptors: {DischargeDescriptor.clear},
);
final pastyCloudyDischargeRecipe = DischargeRecipe(
  dischargeType: DischargeType.sticky,
  dischargeFrequencies: {DischargeFrequency.twice},
  dischargeDescriptors: {DischargeDescriptor.pasty, DischargeDescriptor.cloudy},
);
