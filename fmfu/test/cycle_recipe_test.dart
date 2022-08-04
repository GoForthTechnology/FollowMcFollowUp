
import 'package:fmfu/models/observation.dart';
import 'package:fmfu/utils/cycle_recipe.dart';

void main() {
  var recipe = CycleRecipe(
      FlowRecipe(NormalDistribution(5, 1), Flow.heavy, Flow.veryLight),
      PreBuildUpRecipe(NormalDistribution(4, 1)),
      BuildUpRecipe(NormalDistribution(4, 1)),
      PostPeakRecipe(NormalDistribution(12, 1))
  );
  print(recipe.getObservations());
}