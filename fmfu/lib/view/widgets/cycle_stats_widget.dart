import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmfu/model/chart.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';
import 'package:provider/provider.dart';

class CycleStatsWidget extends StatefulWidget {
  final Cycle cycle;

  const CycleStatsWidget({Key? key, required this.cycle}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CycleStatsState();
}

class CycleStatsState extends State<CycleStatsWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartListViewModel>(builder: (context, model, child) => Form(
      key: _formKey,
      child:  Padding(padding: EdgeInsets.only(left: 2), child: Column(
        children: [
          Row(children: [
            const Text("LPPP: "),
            SizedBox(width: 40, height: 30, child: TextFormField(
              initialValue: widget.cycle.cycleStats.lengthOfPostPeakPhase?.toString() ?? "",
              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSaved: (value) {
                int? length;
                if (value != null) {
                  length = int.tryParse(value);
                }
                model.setLengthOfPostPeakPhase(widget.cycle.index, length);
              },
            ))
          ]),
          Row(children: [
            const Text("MCS: "),
            SizedBox(width: 40, height: 30, child: TextFormField(
              initialValue: widget.cycle.cycleStats.mucusCycleScore?.toString() ?? "",
              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSaved: (value) {
                double? score;
                if (value != null) {
                  score = double.tryParse(value);
                }
                model.setMucusCycleScore(widget.cycle.index, score);
              },
            ))
          ]),
          Padding(padding: EdgeInsets.only(top: 4), child: ElevatedButton(onPressed: () {

          }, child: const Text("Save"), )),
        ]
      ),
    )));
  }
}