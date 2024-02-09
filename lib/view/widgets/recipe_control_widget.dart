
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/exercises.dart';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/utils/non_negative_integer.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:fmfu/view_model/recipe_control_view_model.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class RecipeControlWidget extends StatefulWidget {
  const RecipeControlWidget({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeControlWidgetState();
}

class Item {
  bool isExpanded = false;
  final PanelType panelType;

  Item(this.panelType);
}

enum PanelType {
  flow,
  preBuildUp,
  buildUp,
  postPeak,
  additionalCircumstances,
  errorScenarios,
  followUpSchedule,
  instructions,
  ;

  String get title {
    switch(this) {
      case PanelType.flow:
        return "Flow";
      case PanelType.preBuildUp:
        return "Pre-Buildup";
      case PanelType.buildUp:
        return "Buildup";
      case PanelType.postPeak:
        return "Post-Peak";
      case PanelType.additionalCircumstances:
        return "Additional Circumstances";
      case PanelType.errorScenarios:
        return "Error Scenarios";
      case PanelType.followUpSchedule:
        return "Followup Schedule";
      case PanelType.instructions:
        return "Instructions";
    }
  }
}

class _RecipeControlWidgetState extends State<RecipeControlWidget> {

  final List<Item> _items = PanelType.values.map((type) => Item(type)).toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartListViewModel>(builder: (context, model, child) => Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Padding(padding: const EdgeInsets.all(10), child: SingleChildScrollView(child: ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 350),
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Recipe Controls", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          _templateSelector(model.recipeControlViewModel),
          ExpansionPanelList(
            expansionCallback: (index, isExpanded) => setState(() {
              _items[index].isExpanded = isExpanded;
              for (int i=0; i<_items.length; i++) {
                if (i == index) {
                  continue;
                }
                _items[i].isExpanded = false;
              }
            }),
            children: _items.map((item) {
              List<Widget> body;
              switch(item.panelType) {
                case PanelType.flow:
                  body = _flowWidgets(context, model.recipeControlViewModel.flowModel);
                  break;
                case PanelType.preBuildUp:
                  body = _preBuildUpWidgets(context, model.recipeControlViewModel.preBuildUpModel);
                  break;
                case PanelType.buildUp:
                  body = _buildUpWidgets(context, model.recipeControlViewModel.buildUpModel);
                  break;
                case PanelType.postPeak:
                  body = _postPeakWidgets(context, model.recipeControlViewModel.postPeakModel);
                  break;
                case PanelType.additionalCircumstances:
                  body = _additionalCircumstanceWidgets(model.recipeControlViewModel);
                  break;
                case PanelType.errorScenarios:
                  body = _errorScenarioWidgets(model.recipeControlViewModel);
                  break;
                case PanelType.followUpSchedule:
                  body = _followUpScheduleWidgets(context, model);
                  break;
                case PanelType.instructions:
                  body = _instructionWidgets(context, model);
                  break;
              }
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) => Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _subSectionHeader(item.panelType.title),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(children: body),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        ]),
      )))
    ));
  }

  List<Widget> _followUpScheduleWidgets(BuildContext context, ChartViewModel model) {
    List<Widget> followUpChips = model.followUps().mapIndexed((index, date) => Tooltip(
      message: "Follow Up #${index + 1}",
      child: Chip(
        label: Text(date.toString("MM/dd")),
        onDeleted: () {
          model.removeFollowUp(date);
        },
      ),
    )).toList();

    Widget addFollowUpButton = Padding(padding: const EdgeInsets.all(10), child: Center(child: TextButton(
      onPressed: () {
        showDatePicker(
            context: context,
            initialDate: model.nextFollowUpDate().toDateTimeUnspecified(),
            firstDate: model.startOfCharting().toDateTimeUnspecified(),
            lastDate: model.latestStartOfCharting().toDateTimeUnspecified(),
            selectableDayPredicate: (day) {
              var date = LocalDate.dateTime(day);
              if (date < model.startOfCharting()) {
                return false;
              }
              return !model.hasFollowUp(LocalDate.dateTime(day));
            }).then((date) {
          if (date != null) {
            model.addFollowUp(LocalDate.dateTime(date));
          }
        });
      }, child: const Text("Add Follow Up"),
    )));

    Widget startOfCharting = Row(children: [
      const Text("Start of Charting: "),
      const Spacer(),
      ElevatedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: model.startOfCharting().toDateTimeUnspecified(),
            firstDate: model.earliestStartOfCharting().toDateTimeUnspecified(),
            lastDate: model.latestStartOfCharting().toDateTimeUnspecified(),
          ).then((date) {
            if (date != null) {
              model.setStartOfCharting(LocalDate.dateTime(date));
            }
          });
        },
        child: Text(model.startOfCharting().toString()),
      ),
    ]);

    return [
      startOfCharting,
      Wrap(children: followUpChips,),
      addFollowUpButton,
    ];
  }

  List<Widget> _instructionWidgets(BuildContext context, ChartViewModel model) {
    void promptForDate(LocalDate? currentDate, Function(LocalDate) onChange) {
      final initialDate = currentDate ?? model.startOfCharting();
      showDatePicker(
        context: context,
        initialDate: initialDate.toDateTimeUnspecified(),
        firstDate: model.earliestStartOfCharting().toDateTimeUnspecified(),
        lastDate: model.latestStartOfCharting().toDateTimeUnspecified(),
      ).then((date) {
        if (date != null) {
          onChange(LocalDate.dateTime(date));
        }
      });
    }
    Widget instructionWidget(String title, LocalDate? startingDate, Function(LocalDate?) onDateChange) {
      return Row(children: [
        Text(title),
        const Spacer(),
        Switch(value: startingDate != null, onChanged: (value) {
          if (value) {
            promptForDate(startingDate, onDateChange);
          } else {
            onDateChange(null);
          }
        }),
        if (startingDate != null) ElevatedButton(onPressed: () {
          promptForDate(startingDate, onDateChange);
        }, child: Text(startingDate.toString("MM/dd/yyyy"))),
      ]);
    }
    return [
      instructionWidget("Ask EsQ?", model.startOfAskingEsQ, model.updateAskEsQ),
      instructionWidget("Pre-Peak Yellow Stamps", model.startOfPrePeakYellowStamps, model.updatePrePeakYellowStamps),
      instructionWidget("Post-Peak Yellow Stamps", model.startOfPostPeakYellowStamps, model.updatePostPeakYellowStamps),
    ];
  }

  List<Widget> _errorScenarioWidgets(RecipeControlViewModel model) {
    List<Widget> rowForScenario(ErrorScenario scenario) {
      return [
        _subSubSectionHeader(scenario.name),
        _frequencyControl(
          currentValue: model.errorScenarios[scenario] ?? 0,
          updateValue: (update) => model.updateErrorScenario(scenario, update),
        ),
      ];
    }
    return [
      ...ErrorScenario.values
          .map((v) => rowForScenario(v))
          .toList()
          .expand((e) => e),
    ];
  }

  List<Widget> _additionalCircumstanceWidgets(RecipeControlViewModel model) {
    return [
      _subSubSectionHeader("Unusual Bleeding Frequency"),
      _frequencyControl(
        currentValue: model.unusualBleedingProbability(),
        updateValue: model.updateUnusualBleedingProbability,
      ),

      _subSubSectionHeader("Tail End Brown Bleeding"),

      _subSubSectionHeader("Premenstrual Spotting Length"),
      _lengthControl("Length", model.preMenstrualSpottingLength),

      _subSubSectionHeader("Premenstrual Mucus Length"),
    ];
  }

  List<Widget> _postPeakWidgets(BuildContext context, PostPeakModel model) {
    return [
      _lengthControl("Mucus Length", model.mucusLength, hint: "The number of days of mucus which follow peak day"),
      _subSubSectionHeader("Default Observation"),
      _observation(
        context: context,
        discharge: model.mucusDischargeModel.defaultDischarge,
        removeRecipe: () {},
        canRemove: false,
      ),
      ..._additionalObservations(context, model.mucusDischargeModel),
      _lengthControl("Length", model.length, hint: "The overall length of the post peak phase"),
      _subSubSectionHeader("Default Observation"),
      _observation(
        context: context,
        discharge: model.dischargeModel.defaultDischarge,
        removeRecipe: () {},
        canRemove: false,
      ),
      ..._additionalObservations(context, model.dischargeModel),
    ];
  }

  List<Widget> _buildUpWidgets(BuildContext context, BuildUpModel model) {
    return [
      _lengthControl("Non Peak-Type Length", model.length),
      _subSubSectionHeader("Default Observation"),
      _observation(
        context: context,
        discharge: model.dischargeModel.defaultDischarge,
        removeRecipe: () {},
        canRemove: false,
      ),
      ..._additionalObservations(context, model.dischargeModel),
      _lengthControl("Peak-Type Length", model.peakTypeLength),
      _subSubSectionHeader("Default Observation"),
      _observation(
        context: context,
        discharge: model.peakTypeDischargeModel.defaultDischarge,
        removeRecipe: () {},
        canRemove: false,
      ),
      ..._additionalObservations(context, model.peakTypeDischargeModel),
    ];
  }

  List<Widget> _preBuildUpWidgets(BuildContext context, PreBuildUpModel model) {
    return [
      _lengthControl("Length", model.length),
      _subSubSectionHeader("Default Observation"),
      _observation(
        context: context,
        discharge: model.dischargeModel.defaultDischarge,
        removeRecipe: () {},
        canRemove: false,
      ),
      ..._additionalObservations(context, model.dischargeModel),
    ];
  }

  List<Widget> _flowWidgets(BuildContext context, FlowModel model) {
    return [
      _lengthControl("Length", model.length),
      Row(children: [
        _dropDownSelector("Min Flow", ["H", "M", "L", "VL"], model.minFlow, model.setMinFlow),
        _dropDownSelector("Max Flow", ["H", "M", "L", "VL"], model.maxFlow, model.setMaxFlow),
      ]),
      _subSubSectionHeader("Default Observation (for L & VL)", padTop: false),
      _observation(
        context: context,
        discharge: model.dischargeModel.defaultDischarge,
        removeRecipe: () {},
        canRemove: false,
      ),
      ..._additionalObservations(context, model.dischargeModel),
    ];
  }

  List<Widget> _additionalObservations(BuildContext context, DischargeModel model) {
    List<Widget> out = [_subSubSectionHeader("Additional Observations")];
    model.additionalRecipes().forEachIndexed((index, recipe) {
      final discharge = recipe.recipe.defaultDischarge;
      out.add(_observation(
        context: context,
        discharge: discharge,
        removeRecipe: () => model.removeAdditionalRecipe(index),
      ));
      out.add(_frequencyControl(
        currentValue: recipe.probability,
        updateValue: (newValue) => model.updateAdditionalRecipe(
            index, discharge.getRecipe(), newValue),
      ));
    });
    out.add(Center(child: TextButton(onPressed: (){
      _showObservationDialog(context, null, (recipe) => model.addAdditionalRecipe(recipe, 0.5));
    }, child: const Text("Add Observation"))));
    return out;
  }

  Widget _templateSelector(RecipeControlViewModel model) {
    return Consumer<ExerciseListViewModel>(builder: (context, exerciseModel, child) {
      return FutureBuilder<List<Exercise>>(
        future: exerciseModel.getCustomExercises(ExerciseType.dynamic),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<DynamicExercise> customExercises = snapshot.data?.cast() ?? [];
          List<DynamicExercise> exercises = [];
          exercises.addAll(exerciseModel
              .getExercises(ExerciseType.dynamic)
              .cast<DynamicExercise>()
              .where((e) => e.recipe != null));
          exercises.addAll(customExercises);
          if (model.templateIndex() >= exercises.length) {
            throw Exception("Template index: ${model.templateIndex()} is out of bounds ${exercises.length}");
          }
          return Row(children: [
            const Tooltip(message: "Select a standard scenario to preset the controls below", child: Text("Template")),
            Padding(padding: const EdgeInsets.all(10), child: DropdownButton<int>(
              value: model.templateIndex(),
              items: exercises.mapIndexed((i, e) => DropdownMenuItem<int>(
                value: i,
                child: Text(e.name),
              )).toList(),
              onChanged: (i) {
                if (i == null) {
                  return;
                }
                if (i == model.templateIndex()) {
                  return;
                }
                final exercise = exercises[i];
                model.updateTemplateIndex(i);
                model.applyTemplate(exercise.recipe!);
              },
            ))
          ]);
        },
      );
    });
  }

  Widget _dropDownSelector(String title, List<String> items, Flow Function() getFlow, Function(Flow) setFlow) {
    return Row(children: [
      Text(title),
      Padding(padding: const EdgeInsets.all(10), child: DropdownButton<String>(
        value: getFlow().code.toUpperCase(),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: (value) {
          setFlow(Flow.fromCode(value!)!);
        },
      )),
    ]);
  }

  Widget _subSectionHeader(String title, {bool padTop = true}) {
    Widget widget = Text(title, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18));
    if (padTop) {
      widget = Padding(padding: const EdgeInsets.only(top: 10), child: widget);
    }
    return widget;
  }

  Widget _subSubSectionHeader(String title, {bool padTop = true}) {
    Widget widget = Text(title, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14));
    if (padTop) {
      widget = Padding(padding: const EdgeInsets.only(top: 10), child: widget);
    }
    return widget;
  }

  Widget _observation({
    required BuildContext context,
    required DischargeInterface discharge,
    required Function() removeRecipe,
    bool canRemove = true}) {
    return Padding(padding: const EdgeInsets.only(top: 10), child: Row(children: [
      Padding(padding: const EdgeInsets.only(right: 10), child: Text(discharge.getRecipe().getObservations().join(", "))),
      IconButton(onPressed: () {
        _showObservationDialog(context, discharge.getRecipe(), discharge.setRecipe);
      }, icon: const Icon(Icons.edit, color: Colors.blue,)),
      if (canRemove) IconButton(onPressed: () {
        removeRecipe();
      }, icon: const Icon(Icons.delete, color: Colors.blue,)),
    ]));
  }

  Widget _frequencyControl({required double currentValue, required Function(double) updateValue}) {
    double value = (100 * currentValue).floorToDouble();
    return Row(children: [
      Text("Frequency: $value%"),
      Slider(
        value: value,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (val) => updateValue(val / 100),
      ),
    ]);
  }

  Widget _lengthControl(String title, NonNegativeInteger value, {String? hint}) {
    Widget titleWidget = Text("$title: ${value.get().toString()}");
    if (hint != null) {
      titleWidget = Tooltip(message: hint, child: titleWidget);
    }
    bool canDecrement = value.get() > 0;
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      titleWidget,
      const Spacer(),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ElevatedButton(
          onPressed: canDecrement ? () => value.decrement() : null, child: const Text("-"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ElevatedButton(
          onPressed: () => value.increment(), child: const Text("+"),
        ),
      ),
    ]);
  }

  void _showObservationDialog(BuildContext context, DischargeRecipe? initialRecipe, Function(DischargeRecipe) onSave) {
    showDialog(context: context, builder: (context) => ObservationDialogWidget(
        onSave: onSave, initialDischargeRecipe: initialRecipe));
  }
}

class ObservationDialogWidget extends StatefulWidget {
  final DischargeRecipe? initialDischargeRecipe;
  final Function(DischargeRecipe) onSave;
  const ObservationDialogWidget({super.key, required this.onSave, this.initialDischargeRecipe});

  @override
  State<StatefulWidget> createState() => ObservationDialogState();
}

class ObservationDialogState extends State<ObservationDialogWidget> {
  DischargeType? dischargeType;
  final Set<DischargeDescriptor> dischargeDescriptors = {};
  final Set<DischargeFrequency> dischargeFrequencies = {};

  @override
  void initState() {
    if (widget.initialDischargeRecipe != null) {
      dischargeType = widget.initialDischargeRecipe!.dischargeType;
      dischargeDescriptors.addAll(widget.initialDischargeRecipe!.dischargeDescriptors);
      dischargeFrequencies.addAll(widget.initialDischargeRecipe!.dischargeFrequencies);
    }
    super.initState();
  }

  DischargeRecipe? recipe() {
    if (dischargeType == null) {
      return null;
    }
    return DischargeRecipe(
      dischargeType: dischargeType!,
      dischargeDescriptors: dischargeDescriptors.toSet(),
      dischargeFrequencies: dischargeFrequencies.toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configure Observation"),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text("Discharge Type (select one)"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...DischargeType.values.map((t) => ElevatedButton(
            onPressed: () => setState(() {
              if (dischargeType == t) {
                dischargeType = null;
              } else {
                dischargeType = t;
              }
              if (!(dischargeType?.requiresDescriptors ?? false)) {
                dischargeDescriptors.clear();
              }
            }),
            style: ElevatedButton.styleFrom(backgroundColor: dischargeType == t ? Colors.pinkAccent : Colors.blue),
            child: Text(t.code),
          )),
        ]),
        const Text("Eligible Discharge Descriptors"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...DischargeDescriptor.values.map((t) => DischargeButton(activeValues: dischargeDescriptors, item: t, setState: setState, enabled: dischargeType?.requiresDescriptors ?? false,)),
        ]),
        const Text("Eligible Discharge Frequencies"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...DischargeFrequency.values.map((t) => DischargeButton(activeValues: dischargeFrequencies, item: t, setState: setState, enabled: dischargeType != null)),
        ]),
        Text(recipe()?.getObservations().join(", ") ?? ""),
      ]),
      actions: [
        TextButton(onPressed: () {
          final newRecipe = recipe();
          if (newRecipe != null) {
            widget.onSave(newRecipe);
          }
          Navigator.of(context).pop("OK");
        }, child: const Text("Save")),
      ],
    );
  }
}

class DischargeButton<T extends DischargeComponent> extends StatelessWidget {
  final T item;
  final bool enabled;
  final Function(Function()) setState;
  final Set<T> activeValues;

  const DischargeButton({super.key, required this.activeValues, required this.item, required this.setState, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !enabled ? null : () {
        setState(() {
          if (activeValues.contains(item)) {
            activeValues.remove(item);
          } else {
            activeValues.add(item);
          }
        });
      },
      style: ElevatedButton.styleFrom(backgroundColor: (activeValues.contains(item)) ? Colors.pinkAccent : Colors.blue),
      child: Text(item.code),
    );
  }
}