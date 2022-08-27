import 'package:fmfu/logic/observation_parser.dart';
import 'package:fmfu/model/observation.dart';
import 'package:test/test.dart';


void main() {
  group("Flow", () {
    test("without discharge summary", () {
      for (var flow in Flow.values) {
        String input = flow.code;
        if (flow.requiresDischargeSummary) {
          expect(() => parseObservation(input), throwsException);
        } else {
          Observation observation = parseObservation(input);
          expect(observation.flow!, flow);
          expect(observation.dischargeSummary, isNull);
        }
      }
    });
    test("with discharge summary", () {
      for (var flow in Flow.values) {
        String input = "${flow.code} 0 AD";
        if (flow.requiresDischargeSummary) {
          Observation observation = parseObservation(input);
          expect(observation.flow, flow);
          expect(observation.dischargeSummary, isNotNull);
        } else {
          expect(() => parseObservation(input), throwsException);
        }
      }
    });
    test("with text after discharge summary", () {
      String input = "VL 0 AD C";
      expect(() => parseObservation(input), throwsException);
    });
  });
  group("Discharge summary", () {
    test("with everything", () {
      for (var frequency in DischargeFrequency.values) {
        for (var type in DischargeType.values) {
          if (type.requiresDescriptors) {
            for (int i=1; i<DischargeDescriptor.values.length; i++) {
              var expected = Observation(
                dischargeSummary: DischargeSummary(
                  dischargeType: type,
                  dischargeFrequency: frequency,
                  dischargeDescriptors: DischargeDescriptor.values.sublist(0, i),
                ),
              );
              var actual = parseObservation(expected.toString());
              expect(actual, equals(expected), reason: "$expected");
            }
          } else {
            var expected = Observation(
              dischargeSummary: DischargeSummary(
                dischargeType: type,
                dischargeFrequency: frequency,
              ),
            );
            var actual = parseObservation(expected.toString());
            expect(actual, equals(expected), reason: "$expected");
          }
        }
      }
    });
    test("with duplicate descriptor", () {
      String input = "6 YY AD";
      expect(() => parseObservation(input), throwsException);
    });
    test("with missing color", () {
      for (var descriptor in DischargeDescriptor.values.where((d) => d.requiresColor)) {
        var observation = Observation(
          dischargeSummary: DischargeSummary(
            dischargeType: DischargeType.stretchy,
            dischargeFrequency: DischargeFrequency.once,
            dischargeDescriptors: [descriptor],
          )
        );
        expect(() => parseObservation(observation.toString()), throwsException);
      }
    });
    test("should not have descriptors", () {
      for (var type in DischargeType.values.where((d) => !d.requiresDescriptors)) {
        var observation = Observation(
            dischargeSummary: DischargeSummary(
              dischargeType: type,
              dischargeFrequency: DischargeFrequency.once,
              dischargeDescriptors: [DischargeDescriptor.yellow],
            )
        );
        expect(() => parseObservation(observation.toString()), throwsException);
      }
    });
    test("should not have descriptors", () {
      for (var type in DischargeType.values.where((d) => d.requiresDescriptors)) {
        var observation = Observation(
            dischargeSummary: DischargeSummary(
              dischargeType: type,
              dischargeFrequency: DischargeFrequency.once,
            )
        );
        expect(() => parseObservation(observation.toString()), throwsException);
      }
    });
  });
}