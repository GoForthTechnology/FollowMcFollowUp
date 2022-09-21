import 'package:flutter/material.dart';
import 'package:fmfu/logic/cycle_error_simulation.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:provider/provider.dart';

class ControlBarWidget extends StatefulWidget {
  static ControlBarWidgetState of(BuildContext context) => context.findAncestorStateOfType<ControlBarWidgetState>()!;

  const ControlBarWidget({Key? key}) : super(key: key);

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
    void updateCycles(ChartListViewModel model) {
      model.updateCharts(
        _getRecipe(),
        errorScenarios: errorScenarios,
        askESQ: askESQ,
        prePeakYellowStamps: prePeakYellowStamps,
        postPeakYellowStamps: postPeakYellowStamps,
      );
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<ChartListViewModel>(
            builder: (context, model, child) => Column(
          children: [
            Row(children: [
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
                    updateCycles(model);
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
                    updateCycles(model);
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
                    updateCycles(model);
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
                    updateCycles(model);
                  });
                },
              ),
            ]),
            Row(
              children: [
                const Text("Flow Length: "),
                Text(flowLength.toString()),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(onPressed: () {
                    setState(() {
                      if (flowLength > 0) {
                        flowLength--;
                        updateCycles(model);
                      }
                    });
                  }, child: const Text("-")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(onPressed: () {
                    setState(() {
                      flowLength++;
                      updateCycles(model);
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
                        updateCycles(model);
                      }
                    });
                  }, child: const Text("-")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(onPressed: () {
                    setState(() {
                      preBuildupLength++;
                      updateCycles(model);
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
                        updateCycles(model);
                      }
                    });
                  }, child: const Text("-")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(onPressed: () {
                    setState(() {
                      buildUpLength++;
                      updateCycles(model);
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
                        updateCycles(model);
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
                      updateCycles(model);
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
                        updateCycles(model);
                      }
                    });
                  }, child: const Text("-")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(onPressed: () {
                    setState(() {
                      postPeakLength++;
                      updateCycles(model);
                    });
                  }, child: const Text("+")),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Instruction Controls    ", style: TextStyle(fontWeight: FontWeight.bold),),
                const Text("Ask ESQ: "),
                Switch(value: askESQ, onChanged: (value) {
                  setState(() {
                    askESQ = value;
                    if (!askESQ) {
                      prePeakYellowStamps = false;
                    }
                    updateCycles(model);
                  });
                }),
                const Text("Pre-Peak Yellow Stamps: "),
                Switch(value: prePeakYellowStamps, onChanged: (value) {
                  setState(() {
                    prePeakYellowStamps = value;
                    if (prePeakYellowStamps) {
                      askESQ = true;
                    }
                    updateCycles(model);
                  });
                }),
                const Text("Post-Peak Yellow Stamps: "),
                Switch(value: postPeakYellowStamps, onChanged: (value) {
                  setState(() {
                    postPeakYellowStamps = value;
                    updateCycles(model);
                  });
                }),
              ],
            ),
            Row(
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
                    model.updateErrors(errorScenarios);
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
                    model.updateErrors(errorScenarios);
                  });
                }),
              ],
            ),
            if (model.incrementalMode) Row(children: [
              ElevatedButton(onPressed: () {
                model.addCycle(
                  _getRecipe(),
                  errorScenarios: errorScenarios,
                  askESQ: askESQ,
                  prePeakYellowStamps: prePeakYellowStamps,
                  postPeakYellowStamps: postPeakYellowStamps,
                );
              }, child: const Text("Add Cycle")),
            ]),
          ],
        )));
  }
}

