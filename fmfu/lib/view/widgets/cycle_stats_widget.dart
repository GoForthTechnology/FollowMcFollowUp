import 'package:flutter/material.dart';

class CycleStatsWidget extends StatefulWidget {
  const CycleStatsWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CycleStatsState();
}

class CycleStatsState extends State<CycleStatsWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text("LPM: "),
            SizedBox(width: 40, height: 30, child: TextFormField())
          ]),
          Row(children: [
            const Text("MCS: "),
            SizedBox(width: 40, height: 30, child: TextFormField())
          ]),
          ElevatedButton(
              onPressed: () {},
              child: const Text("Save"),
          ),
        ]
      ),
    );
  }
}