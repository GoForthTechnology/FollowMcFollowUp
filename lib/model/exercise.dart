
import 'package:json_annotation/json_annotation.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/view_model/chart_view_model.dart';

part 'exercise.g.dart';

@JsonSerializable(explicitToJson: true)
class ExerciseState {
  final List<Instruction> activeInstructions;
  final List<ErrorScenario> errorScenarios;
  final List<Cycle> cycles;

  ExerciseState(this.activeInstructions, this.errorScenarios, this.cycles);

  static ExerciseState fromChartViewModel(ChartViewModel model) {
    return ExerciseState(model.activeInstructions, model.errorScenarios, model.cycles);
  }

  factory ExerciseState.fromJson(Map<String, dynamic> json) => _$ExerciseStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseStateToJson(this);
}
