import 'package:fmfu/model/chart.dart';
import 'package:test/test.dart';

void main() {
  group("Empty Cycle", () {
    test("Has no entries", () {
      expect(Cycle.empty().entries.length, 0);
    });
    test("Has no sticker corrections", () {
      expect(Cycle.empty().stickerCorrections.length, 0);
    });
    test("Has no observation corrections", () {
      expect(Cycle.empty().observationCorrections.length, 0);
    });
  });
}