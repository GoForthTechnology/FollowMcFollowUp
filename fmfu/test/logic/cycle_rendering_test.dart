
import 'package:fmfu/logic/cycle_rendering.dart';
import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/observation.dart';
import 'package:fmfu/model/stickers.dart';
import 'package:test/test.dart';

void main() {
  group("Count of three", ()
  {
    test("for consecutive days of non-peak type mucus pre-peak", () {
      var observations = [
        parseObservation("H"),     //0
        parseObservation("M"),     //1
        parseObservation("M"),     //2
        parseObservation("0 AD"),  //3
        parseObservation("6C AD"), //4
        parseObservation("6C AD"), //5
        parseObservation("6C AD"), //6
        parseObservation("0 AD"),  //7
      ];
      var renderedObservations = renderObservations(observations, []);
      expect(renderedObservations[7].getSticker(), Sticker.greenBaby);
      expect(renderedObservations[7].getStickerText(), "1");
    });
  });
}