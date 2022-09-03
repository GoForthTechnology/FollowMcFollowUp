import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/box_grid_widget.dart';
import 'package:fmfu/view/widgets/fup_form_section_widget.dart';

class FupFormScreen extends StatefulWidget {
  static const String routeName = "fupf";

  @override
  State<StatefulWidget> createState() => _FupFormScreenState();
}

class _FupFormScreenState extends State<FupFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up Form"),
      ),
      body: Page7(),
    );
  }
}

Widget title(String code, String text, {TextStyle? style}) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text("$code. ", style: TextStyle(fontWeight: FontWeight.bold)),
    Text(text, style: style),
  ]);
}

class Page7 extends StatelessWidget {
  static const TextStyle sectionHeadingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  const Page7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 2000, width: 1000, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("8) CHARTING (NaProTRACKING) -- Review & Assessment", style: sectionHeadingStyle),
      const Text("(Code for this section: 1=Unsatisfactory Application  2=Satisfactory Applicaiont  X=Reviewed - assessment not indicated  -- = Not Applicable)"),
      Padding(padding: const EdgeInsets.all(10), child: Expanded(child: Column(children: [
        FollowUpFormSectionWidget(items: [
          FollowUpFormItem(
            section: 8,
            subSection: "A",
            description: "CHART REVIEWED WITH FCP/FCPI (X)",
            descriptionStyle: TextStyle(fontWeight: FontWeight.bold),
            acceptableInputs: ["X"],
          )
        ]),
        FollowUpFormSectionWidget(items: [
          FollowUpFormItem(
            section: 8,
            subSection: "B",
            description: "Peak Days correctly identified (1,2,X) \n The Peak Day was confidentally identified (Y,N,X)",
            splitBoxes: true,
            acceptableInputs: ["Y", "N", "X"],
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "C",
            description: "Correctly charts stamps",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "D",
            description: "Correctly charts recording system",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "",
            descriptionStyle: const TextStyle(fontWeight: FontWeight.bold),
            description: "RECORDING SYSTEM (VDRS) REVIEWED (X)",
            disabledCells: {2, 3, 4, 5, 6, 7},
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "E",
            description: "Charts at the end of the day / Who does the charting? (M, W, B)",
            splitBoxes: true,
            acceptableInputs: ["M", "W", "B"],
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "F",
            description: "Charts the most fertile sign of the day",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "G",
            description: "Charts the menstrual flow -- H, M, L, VL, B",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "H",
            description: "Charts brow/black bleeding as B",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "I",
            description: "Charts bleeding other than the period",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "J",
            description: "Charts dry/mucus on L, VL, and B days",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "K",
            description: "Charts all acts of intercourse -- I",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "L",
            description: "Charts discharge after intercourse on its merits",
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "M",
            description: "Are barrier methods being used? (Y or N)",
            disabledCells: {0, 1},
            acceptableInputs: ["Y", "N"],
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "N",
            description: "Is coitus interruptus or withdrawal being used? (Y or N)",
            disabledCells: {0, 1},
            acceptableInputs: ["Y", "N"],
          ),
          FollowUpFormItem(
            section: 8,
            subSection: "O",
            description: "Discuss concomitant use of barrier methods, coitus interruptus and withdrawal (X)",
            disabledCells: {0, 1},
          ),
        ]),
      ]))),
    ])));
  }
}
