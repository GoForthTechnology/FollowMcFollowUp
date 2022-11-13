
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/utils/non_negative_integer.dart';
import 'package:fmfu/view_model/exercise_list_view_model.dart';
import 'package:fmfu/view_model/recipe_control_view_model.dart';
import 'package:provider/provider.dart';

class RecipeControlWidget extends StatelessWidget {
  const RecipeControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeControlViewModel>(builder: (context, model, child) => Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Padding(padding: const EdgeInsets.all(10), child: SingleChildScrollView(child: ConstrainedBox(constraints: const BoxConstraints.tightFor(width: 350),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Recipe Controls", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        _templateSelector(model),
        ..._flowWidgets(context, model.flowModel),
        const Divider(),
        ..._preBuildUpWidgets(context, model.preBuildUpModel),
        const Divider(),
        ..._buildUpWidgets(context, model.buildUpModel),
        const Divider(),
        ..._postPeakWidgets(context, model.postPeakModel),
        const Divider(),
        ..._additionalCircumstanceWidgets(model),
      ]))))));
  }

  List<Widget> _additionalCircumstanceWidgets(RecipeControlViewModel model) {
    print("FOO: ${model.unusualBleedingProbability()}");
    return [
      _subSectionHeader("Additional Circumstances"),
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
      _subSectionHeader("Post-Peak"),
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
      _subSectionHeader("Buildup"),
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
      _subSectionHeader("Pre-Buildup"),
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
      _subSectionHeader("Flow", padTop: false),
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
      List<DynamicExercise> exercises = [];
      exercises.addAll(exerciseModel
          .getExercises(ExerciseType.dynamic)
          .cast<DynamicExercise>()
          .where((e) => e.recipe != null));
      exercises.addAll(exerciseModel
          .getCustomExercises(ExerciseType.dynamic)
          .cast<DynamicExercise>());
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
              print("Null value");
              return;
            }
            if (i == model.templateIndex()) {
              print("Same index");
              return;
            }
            final exercise = exercises[i];
            print("Applying exercise: ${exercise.name}");
            model.updateTemplateIndex(i);
            model.applyTemplate(exercise.recipe!);
          },
        ))
      ]);
    });
  }

  Widget _dropDownSelector(String title, List<String> items, Flow Function() getFlow, Function(Flow) setFlow) {
    return Row(children: [
      Text(title),
      Padding(padding: EdgeInsets.all(10), child: DropdownButton<String>(
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