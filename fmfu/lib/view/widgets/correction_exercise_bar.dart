import 'package:flutter/material.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:fmfu/view/widgets/cycle_widget.dart';
import 'package:fmfu/view/widgets/sticker_widget.dart';
import 'package:fmfu/view_model/chart_correction_view_model.dart';
import 'package:fmfu/view_model/exercise_view_model.dart';
import 'package:provider/provider.dart';

class CorrectionExerciseBar extends StatelessWidget {
  const CorrectionExerciseBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartCorrectionViewModel, ExerciseViewModel>(builder: (context, model, exerciseModel, child) => Row(children: [
      const Text("Select a Sticker: "),
      StickerSelectionRow(
        includeYellow: true,
        selectedSticker: exerciseModel.currentStickerSelection,
        onSelect: exerciseModel.updateStickerSelection,
      ),
      const Padding(padding: EdgeInsets.only(left: 10), child: Text("Select a Text Option: ")),
      StickerTextSelectionRow(
        selectedText: exerciseModel.currentStickerTextSelection,
        onSelect: exerciseModel.updateStickerTextSelection,
      ),
      const Padding(padding: EdgeInsets.only(left: 10), child: Text("Current Selection: ", style: TextStyle(fontWeight: FontWeight.bold))),
      StickerWidget(
        stickerWithText: exerciseModel.getCurrentStickerWithText() ?? StickerWithText(Sticker.grey, null),
        onTap: () {},
      ),
      Padding(padding: const EdgeInsets.only(left: 10), child: Column(children: [
        ElevatedButton(
          onPressed: !exerciseModel.canSaveAnswer() ? null : () {
            exerciseModel.submitAnswer(model.entryIndex);
            exerciseModel.clearSelection();
            // This needs to come second because submitting answer checks the
            // current entry index...
            model.nextEntry();
          },
          child: Text(
              exerciseModel.hasAnswer(model.entryIndex) ? "Update Answer" : "Submit Answer"
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 10), child: ElevatedButton(
          onPressed: !exerciseModel.hasAnswer(model.entryIndex) ? null : () {
            exerciseModel.clearAnswer(model.entryIndex);
          },
          child: const Text("Clear Answer"),
        )),
      ]))
    ]));
  }

}