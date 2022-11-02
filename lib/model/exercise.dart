
import 'package:fmfu/model/rendered_observation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/model/instructions.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:time_machine/time_machine.dart';

part 'exercise.g.dart';

@JsonSerializable(explicitToJson: true)
class ExerciseState {
  final List<Instruction> activeInstructions;
  final Set<ErrorScenario> errorScenarios;
  final List<Cycle> cycles;
  @LocalDateJsonConverter()
  final List<LocalDate> followUps;
  @LocalDateJsonConverter()
  final LocalDate startOfCharting;

  ExerciseState(this.activeInstructions, this.errorScenarios, this.cycles, this.followUps, this.startOfCharting);

  static ExerciseState fromChartViewModel(ChartViewModel model) {
    return ExerciseState(model.activeInstructions, model.errorScenarios, model.cycles, model.followUps(), model.startOfCharting());
  }

  factory ExerciseState.fromJson(Map<String, dynamic> json) => _$ExerciseStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseStateToJson(this);
}
