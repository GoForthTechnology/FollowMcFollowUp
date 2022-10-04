import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_view_model.dart';
import 'package:time_machine/time_machine.dart';

class ControlBarWidget extends StatefulWidget {
  final ChartViewModel model;

  static ControlBarWidgetState of(BuildContext context) => context.findAncestorStateOfType<ControlBarWidgetState>()!;

  const ControlBarWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ControlBarWidgetState();
}

class ControlBarWidgetState extends State<ControlBarWidget> {

  double unusualBleedingFrequency = CycleRecipe.defaultUnusualBleedingFrequency;
  double prePeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  double prePeakPeakTypeFrequency = CycleRecipe.defaultPrePeakPeakTypeFrequency;
  double postPeakMucusPatchFrequency = CycleRecipe.defaultMucusPatchFrequency;
  int flowLength = CycleRecipe.defaultFlowLength;
  int preBuildupLength = CycleRecipe.defaultPreBuildupLength;
  int buildUpLength = CycleRecipe.defaultBuildUpLength;
  int peakTypeLength = CycleRecipe.defaultPeakTypeLength;
  int postPeakLength = CycleRecipe.defaultPostPeakLength;
  bool askESQ = false;
  bool prePeakYellowStamps = false;
  bool postPeakYellowStamps = false;
  int toggles = 0;

  List<ErrorScenario> errorScenarios = [];

  CycleRecipe _getRecipe() {
    return CycleRecipe.create(
      prePeakMucusPatchProbability: prePeakMucusPatchFrequency / 100,
      prePeakPeakTypeProbability: prePeakPeakTypeFrequency / 100,
      flowLength: flowLength,
      preBuildUpLength: preBuildupLength,
      buildUpLength: buildUpLength,
      peakTypeLength: peakTypeLength,
      postPeakLength: postPeakLength,
      askESQ: askESQ,
      unusualBleedingProbability: unusualBleedingFrequency / 100);
  }

  @override
  Widget build(BuildContext context) {
    void updateCycles() {
      widget.model.updateCharts(
        _getRecipe(),
        errorScenarios: errorScenarios,
        askESQ: askESQ,
        prePeakYellowStamps: prePeakYellowStamps,
        postPeakYellowStamps: postPeakYellowStamps,
      );
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            _frequencyControlRow(updateCycles),
            _lengthControlRow(updateCycles),
            _instructionRow(updateCycles),
            _errorControlRow(),
            _followUpDatesRow(),
            if (widget.model.incrementalMode) _incrementalControlRow(),
          ],
        ));
  }
  
  Row _frequencyControlRow(Function() updateCycles) {
    return Row(children: [
      const Text("Unusual Bleeding: "),
      Text((unusualBleedingFrequency / 100).toString()),
      Slider(
        value: unusualBleedingFrequency,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (val) {
          setState(() {
            unusualBleedingFrequency = val;
            updateCycles();
          });
        },
      ),
      const Text("Pre-Peak Mucus: "),
      Text((prePeakMucusPatchFrequency / 100).toString()),
      Slider(
        value: prePeakMucusPatchFrequency,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (val) {
          setState(() {
            prePeakMucusPatchFrequency = val;
            updateCycles();
          });
        },
      ),
      const Text("Pre-Peak Peak Type Mucus: "),
      Text((prePeakPeakTypeFrequency / 100).toString()),
      Slider(
        value: prePeakPeakTypeFrequency,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (val) {
          setState(() {
            prePeakPeakTypeFrequency = val;
            updateCycles();
          });
        },
      ),
      const Text("Post-Peak Mucus: "),
      Text((postPeakMucusPatchFrequency / 100).toString()),
      Slider(
        value: postPeakMucusPatchFrequency,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (val) {
          setState(() {
            postPeakMucusPatchFrequency = val;
            updateCycles();
          });
        },
      ),
    ]);
  }

  Row _lengthControlRow(Function() updateCycles) {
    return Row(
      children: [
        const Text("Flow Length: "),
        Text(flowLength.toString()),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              if (flowLength > 0) {
                flowLength--;
                updateCycles();
              }
            });
          }, child: const Text("-")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              flowLength++;
              updateCycles();
            });
          }, child: const Text("+")),
        ),
        const Text("Pre Buildup Length:"),
        Text(preBuildupLength.toString()),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              if (preBuildupLength > 0) {
                preBuildupLength--;
                updateCycles();
              }
            });
          }, child: const Text("-")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              preBuildupLength++;
              updateCycles();
            });
          }, child: const Text("+")),
        ),
        const Text("Buildup Length:"),
        Text(buildUpLength.toString()),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              if (buildUpLength > 0) {
                buildUpLength--;
                updateCycles();
              }
            });
          }, child: const Text("-")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              buildUpLength++;
              updateCycles();
            });
          }, child: const Text("+")),
        ),
        const Text("Peak Type Length:"),
        Text(peakTypeLength.toString()),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              if (peakTypeLength > 0) {
                peakTypeLength--;
                updateCycles();
              }
            });
          }, child: const Text("-")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(onPressed: () {
            if (peakTypeLength == buildUpLength) {
              return;
            }
            setState(() {
              peakTypeLength++;
              updateCycles();
            });
          }, child: const Text("+")),
        ),
        const Text("Post Peak Length:"),
        Text(postPeakLength.toString()),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              if (postPeakLength > 0) {
                postPeakLength--;
                updateCycles();
              }
            });
          }, child: const Text("-")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(onPressed: () {
            setState(() {
              postPeakLength++;
              updateCycles();
            });
          }, child: const Text("+")),
        ),
      ],
    );
  }

  Row _instructionRow(Function() updateCycles) {
    return Row(
      children: [
        const Text("Instruction Controls    ", style: TextStyle(fontWeight: FontWeight.bold),),
        const Text("Ask ESQ: "),
        Switch(value: askESQ, onChanged: (value) {
          setState(() {
            askESQ = value;
            if (!askESQ) {
              prePeakYellowStamps = false;
            }
            updateCycles();
          });
        }),
        const Text("Pre-Peak Yellow Stamps: "),
        Switch(value: prePeakYellowStamps, onChanged: (value) {
          setState(() {
            prePeakYellowStamps = value;
            if (prePeakYellowStamps) {
              askESQ = true;
            }
            updateCycles();
          });
        }),
        const Text("Post-Peak Yellow Stamps: "),
        Switch(value: postPeakYellowStamps, onChanged: (value) {
          setState(() {
            postPeakYellowStamps = value;
            updateCycles();
          });
        }),
      ],
    );
  }

  Row _errorControlRow() {
    return Row(
      children: [
        const Text("Error Controls    ", style: TextStyle(fontWeight: FontWeight.bold),),
        const Text("Forget D4: "),
        Switch(value: errorScenarios.contains(ErrorScenario.forgetD4), onChanged: (value) {
          setState(() {
            if (value) {
              errorScenarios.add(ErrorScenario.forgetD4);
            } else {
              errorScenarios.remove(ErrorScenario.forgetD4);
            }
            widget.model.updateErrors(errorScenarios);
          });
        }),
        const Text("Forget Observation on L, VL or B: "),
        Switch(value: errorScenarios.contains(ErrorScenario.forgetObservationOnFlow), onChanged: (value) {
          setState(() {
            if (value) {
              errorScenarios.add(ErrorScenario.forgetObservationOnFlow);
            } else {
              errorScenarios.remove(ErrorScenario.forgetObservationOnFlow);
            }
            widget.model.updateErrors(errorScenarios);
          });
        }),
      ],
    );
  }

  Row _followUpDatesRow() {
    List<Widget> followUps = widget.model.followUps.map((followUp) => Chip(
      label: Text(followUp.toString()),
      onDeleted: () {
        widget.model.removeFollowUp(followUp);
      },
    )).toList();
    followUps.map((chip) => Padding(padding: const EdgeInsets.only(left: 2, right: 2), child: chip)).toList();

    return Row(
      children: [
        const Text("Follow Up Dates    ", style: TextStyle(fontWeight: FontWeight.bold),),
        ...followUps,
        ElevatedButton(onPressed: () {
          showDatePicker(
            context: context,
            initialDate: DateTime(2022),
            firstDate: DateTime(2022),
            lastDate: DateTime(2023),
            //selectableDayPredicate: (day) => widget.model.hasFollowUp(LocalDate.dateTime(day)),
          ).then((date) {
            if (date != null) {
              widget.model.addFollowUp(LocalDate.dateTime(date));
            }
          });
        }, child: const Text("+")),
      ],
    );
  }

  Row _incrementalControlRow() {
    return Row(children: [
      ElevatedButton(onPressed: () {
        widget.model.addCycle(
          _getRecipe(),
          errorScenarios: errorScenarios,
          askESQ: askESQ,
          prePeakYellowStamps: prePeakYellowStamps,
          postPeakYellowStamps: postPeakYellowStamps,
        );
      }, child: const Text("Add Cycle")),
      ElevatedButton(onPressed: () {
        widget.model.swapLastCycle(
          _getRecipe(),
          errorScenarios: errorScenarios,
          askESQ: askESQ,
          prePeakYellowStamps: prePeakYellowStamps,
          postPeakYellowStamps: postPeakYellowStamps,
        );
      }, child: const Text("Swap Last Cycle")),
    ]);
  }
}

