
import 'dart:math';
import 'package:fmfu/view/widgets/chart_cell_widget.dart';
import 'package:fmfu/view/widgets/chart_widget.dart';
import 'package:fmfu/view/widgets/control_bar_widget.dart';
import 'package:fmfu/view/widgets/cycle_widget.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/logic/cycle_generation.dart';
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/view_model/chart_list_view_model.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartPageState();
}

typedef Corrections = Map<int, Map<int, StickerWithText>>;

class _ChartPageState extends State<ChartPage> {
  Corrections corrections = {};

  @override
  Widget build(BuildContext context) {
    print("Rebuilding CartPage");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Grid Page"),
      ),
      // TODO: figure out how to make horizontal scrolling work...
      body: Consumer<ChartListViewModel>(
        builder: (context, model, child) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              const ControlBarWidget(),
              Expanded(child: Center(child: Padding(
                padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.cycles.length,
                    itemBuilder: (context, index) {
                      return ChartWidget(
                        titleWidget: Text(
                            "Chart #${index+1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        cycles: model.cycles[index],
                      );
                    },
                  ),
              ))),
            ],
          ),
        ),
      )
    );
  }
}