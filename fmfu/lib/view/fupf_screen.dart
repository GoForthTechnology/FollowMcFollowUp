import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/fup_form_section_widget.dart';

class FupFormScreen extends StatefulWidget {
  static const String routeName = "fupf";

  const FupFormScreen({Key? key}) : super(key: key);

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
      body: const Page7(),
    );
  }
}

Widget title(String code, String text, {TextStyle? style}) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text("$code. ", style: const TextStyle(fontWeight: FontWeight.bold)),
    Text(text, style: style),
  ]);
}

class Page7 extends StatelessWidget {
  static const TextStyle sectionHeadingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  const Page7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<FollowUpFormItem>> itemGroups = [
      [
        FollowUpFormItem(
          section: 8,
          subSection: "A",
          questions: [
            Question(
              description: "CHART REVIEWED WITH FCP/FCPI (X)",
              style: const TextStyle(fontWeight: FontWeight.bold),
              acceptableInputs: ["X"],
            ),
          ],
        )
      ], [
        FollowUpFormItem(
          section: 8,
          subSection: "B",
          questions: [
            Question(
              description: "Peak Days correctly identified (1,2,X)",
            ),
            Question(
              description: "The Peak Day was confidently identified (Y,N,X)",
              acceptableInputs: ["Y", "N", "X"],
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "C",
          questions: [
            Question(
              description: "Correctly charts stamps",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "D",
          questions: [
            Question(
              description: "Correctly charts recording system",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "",
          questions: [
            Question(
              description: "RECORDING SYSTEM (VDRS) REVIEWED (X)",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          disabledCells: {2, 3, 4, 5, 6, 7},
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "E",
          questions: [
            Question(
              description: "Charts at the end of the day",
              acceptableInputs: ["M", "W", "B"],
            ),
            Question(
              description: "Who does the charting?",
              acceptableInputs: ["M", "W", "B"],
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "F",
          questions: [
            Question(
              description: "Charts the most fertile sign of the day",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "G",
          questions: [
            Question(
              description: "Charts the menstrual flow -- H, M, L, VL, B",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "H",
          questions: [
            Question(
              description: "Charts brow/black bleeding as B",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "I",
          questions: [
            Question(
              description: "Charts bleeding other than the period",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "J",
          questions: [
            Question(
              description: "Charts dry/mucus on L, VL, and B days",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "K",
          questions: [
            Question(
              description: "Charts all acts of intercourse -- I",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "L",
          questions: [
            Question(
              description: "Charts discharge after intercourse on its merits",
            ),
          ],
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "M",
          questions: [
            Question(
              description: "Are barrier methods being used? (Y or N)",
              acceptableInputs: ["Y", "N"],
            ),
          ],
          disabledCells: {0, 1},
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "N",
          questions: [
            Question(
              description: "Is coitus interruptus or withdrawal being used? (Y or N)",
              acceptableInputs: ["Y", "N"],
            ),
          ],
          disabledCells: {0, 1},
        ),
        FollowUpFormItem(
          section: 8,
          subSection: "O",
          questions: [
            Question(
              description: "Discuss concomitant use of barrier methods, coitus interruptus and withdrawal (X)",
            ),
          ],
          disabledCells: {0, 1},
        ),
      ]
    ];
    return SizedBox(height: 2000, width: 1000, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("8) CHARTING (NaProTRACKING) -- Review & Assessment", style: sectionHeadingStyle),
      const Text("(Code for this section: 1=Unsatisfactory Application  2=Satisfactory Applicaiont  X=Reviewed - assessment not indicated  -- = Not Applicable)"),
      Expanded(child: Padding(padding: const EdgeInsets.all(10), child: Column(
        children: FollowUpFormSectionWidget.create(itemGroups),
      ))),
    ])));
  }
}
