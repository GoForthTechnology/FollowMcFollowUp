import 'package:flutter/material.dart' hide Flow;
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/widgets/cycle_widget.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:fmfu/view_model/exercise_view_model.dart';
import 'package:fmfu/view_model/vdrs_view_model.dart';
import 'package:provider/provider.dart';

class StampSelectionWidget extends StatelessWidget {
  const StampSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseViewModel>(builder: (context, model, child) => _SelectionWidget(
      title: "Select a Stamp for TODAY:",
      content: StickerSelectionRow(
        includeYellow: true,
        selectedSticker: model.currentStickerSelection,
        onSelect: model.updateStickerSelection,
      ),
      advanceOnSubmit: true,
    ));
  }
}

class TextSelectionWidget extends StatelessWidget {
  final Sticker sticker;

  const TextSelectionWidget({super.key, required this.sticker});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseViewModel>(builder: (context, model, child) => _SelectionWidget(
      title: "Select Text option for YESTERDAY:",
      content: StickerTextSelectionRow(
        selectedText: model.currentStickerTextSelection,
        onSelect: model.updateStickerTextSelection,
        sticker: sticker,
      ),
      advanceOnSubmit: false,
    ));
  }
}

class _SelectionWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final bool advanceOnSubmit;

  const _SelectionWidget({required this.title, required this.content, required this.advanceOnSubmit});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartCorrectionViewModel, ExerciseViewModel>(
      builder: (context, correctionModel, exerciseModel, child) => Column(children: [
        Padding(padding: const EdgeInsets.only(left: 10), child: Text(title)),
        content,
        Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(
          onPressed: !exerciseModel.canSubmit() ? null : () {
            exerciseModel.submit();
            if (advanceOnSubmit && correctionModel.showNextButton()) {
              correctionModel.nextEntry();
            }
          },
          child: const Text("Submit Answer"),
        )),
      ]));
  }
}


class VdrsSelectionWidget extends StatelessWidget {
  const VdrsSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartCorrectionViewModel, VdrsViewModel>(builder: (context, correctionModel, exerciseModel, child) {
      List<DropdownMenuItem<Flow?>> flowItems = [
        const DropdownMenuItem(child: DropdownMenuItem(
          value: null,
          child: Text("None"),
        )),
      ];
      flowItems.addAll(Flow.values.map((flow) => DropdownMenuItem(
        value: flow,
        child: Text(flow.name),
      )).toList());

      List<DropdownMenuItem<DischargeType?>> dischargeTypeItems = [
        const DropdownMenuItem(child: DropdownMenuItem(
          value: null,
          child: Text(""),
        )),
      ];
      dischargeTypeItems.addAll(DischargeType.values.map((type) => DropdownMenuItem(
        value: type,
        child: Text(type.name),
      )).toList());

      List<DropdownMenuItem<DischargeFrequency?>> dischargeFrequencyItems = [
        const DropdownMenuItem(child: DropdownMenuItem(
          value: null,
          child: Text(""),
        )),
      ];
      dischargeFrequencyItems.addAll(DischargeFrequency.values.map((val) => DropdownMenuItem(
        value: val,
        child: Text(val.name),
      )).toList());

      return Row(children: [
        const Text("Flow: "),
        DropdownButton<Flow?>(
          value: exerciseModel.currentFlow,
          items: flowItems,
          onChanged: (val) => exerciseModel.updateCurrentFlow(val),
        ),
        const Text("Type: "),
        DropdownButton<DischargeType?>(
          value: exerciseModel.currentDischargeType,
          items: dischargeTypeItems,
          onChanged: (val) => exerciseModel.updateCurrentDischargeType(val),
        ),
        const Text("Descriptors: "),
        ...exerciseModel.currentDischargeDescriptors.map((descriptor) => Chip(
          label: Text(descriptor.name),
          onDeleted: () => exerciseModel.removeDischargeDescriptor(descriptor),
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const DischargeDescriptorWidget(),
            ),
            child: const Chip(label: Text("+"))
        )),
        const Text("Frequency: "),
        DropdownButton<DischargeFrequency?>(
          value: exerciseModel.currentDischargeFrequency,
          items: dischargeFrequencyItems,
          onChanged: (val) => exerciseModel.updateCurrentDischargeFrequency(val),
        ),
      ]);
    });
  }
}

class DischargeDescriptorWidget extends StatefulWidget {
  const DischargeDescriptorWidget({super.key});

  @override
  State<StatefulWidget> createState() => DischargeDescriptorState();
}

class DischargeDescriptorState extends State<DischargeDescriptorWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VdrsViewModel>(builder: (context, model, child) => AlertDialog(
      title: const Text("Select Discharge Descriptors"),
      content: Column(mainAxisSize: MainAxisSize.min, children: DischargeDescriptor.values.map((descriptor) {
        var checked = model.currentDischargeDescriptors.contains(descriptor);
        return CheckboxListTile(
          title: Text(descriptor.name),
          value: checked,
          onChanged: (checked) {
            setState(() {
              if (checked ?? false) {
                model.addDischargeDescriptor(descriptor);
              } else {
                model.removeDischargeDescriptor(descriptor);
              }
            });
          },
        );
      }).toList()),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Close")),
      ],
    ));
  }
}
