import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/view/widgets/comment_section_widget.dart';
import 'package:fmfu/view/widgets/fup_form_section_widget.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: SingleChildScrollView(child: Row(children: [
        Page6(),
        Page7(),
      ],)
    ));
  }
}


class Page6 extends AbstractPage {
  Page6({Key? key}) : super(key: key, pageNum: 6, content: [
    const Text("5) HEALTH AND HYGIENE REVIEW (\u2714)", style: sectionHeadingStyle),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      children: FollowUpFormSectionWidget.create(page6Items1),)),
    CommentSectionWidget(numRows: 10, comments: [
      FollowUpFormComment(
        date: DateTime.now(),
        followUpNum: 1,
        sectionNum: 5,
        problem: "A totally not made up problem",
        planOfAction: "A really great and awesome plan",
      ),
    ]),
    const Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text("6) PICTURE DICTIONARY PRESENTED -- TODO", style: sectionHeadingStyle)),
    const Text("7) DEFINITIONS -- REVIEW & ASSESSMENT", style: sectionHeadingStyle),
    const Text("(Code for this section: 1=Unsatisfactory knowledge  2=Satisfactory knowledge  \u2714=Reviewed - assessment not indicated  -- = Not Applicable)"),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      children: FollowUpFormSectionWidget.create(page6Items2),)),
  ]);
}

class Page7 extends AbstractPage {
  Page7({Key? key}) : super(key: key, pageNum: 7, content: [
    const Text("8) CHARTING (NaProTRACKING) -- Review & Assessment", style: sectionHeadingStyle),
    const Text("(Code for this section: 1=Unsatisfactory Application  2=Satisfactory Application  \u2714=Reviewed - assessment not indicated  -- = Not Applicable)"),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      children: FollowUpFormSectionWidget.create(page7Items),)),
    CommentSectionWidget(numRows: 16, comments: [
      FollowUpFormComment(
        date: DateTime.now(),
        followUpNum: 1,
        sectionNum: 8,
        problem: "A totally not made up problem",
        planOfAction: "A really great and awesome plan",
      ),
    ]),
  ]);
}

class Page8 extends AbstractPage {
  const Page8({Key? key}) : super(key: key, pageNum: 8, content: const [
    CommentSectionWidget(numRows: 31, comments: []),
  ]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 2000, width: 1000, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
    ])));
  }
}

abstract class AbstractPage extends StatelessWidget {
  static const double pageWidth = 1000;

  final int pageNum;
  final List<Widget> content;

  const AbstractPage({Key? key, required this.pageNum, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FollowUpFormComment> comments = [FollowUpFormComment(date: DateTime.now(), followUpNum: 1, sectionNum: 8, problem: "Some problem", planOfAction: "a really great plan")];
    return SizedBox(height: 1300, width: pageWidth, child: Padding(padding: const EdgeInsets.all(20), child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget(),
        ...content,
      ],
    )));
  }

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.black),
      height: 40,
      width: pageWidth,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(pageNum % 2 == 0 ? pageNum.toString() : "", style: pageTitleStyle,),
          Text(
            pageNum % 2 == 0 ? "CREIGHTON MODEL FertilityCARE System" : "Follow-Up Form",
            style: pageTitleStyle,
          ),
          Text(pageNum % 2 == 1 ? pageNum.toString() : "", style: pageTitleStyle,),
        ],
      )),
    );
  }
}


const pageTitleStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
const TextStyle sectionHeadingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const List<List<FollowUpFormItem>> page6Items1 = [
  [
    FollowUpFormItem(
      section: 5,
      subSection: "A",
      questions: [
        Question(
          description: "Vagina is a self cleaning organ (\u2714).",
          acceptableInputs: ["\u2714"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "B",
      questions: [
        Question(
          description: "There is no need to douche (\u2714)",
          acceptableInputs: ["\u2714"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "C",
      questions: [
        Question(
          description: "Do you use tampons (1), pads (2), or minipads (3)?",
          acceptableInputs: ["", "1", "2", "3"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "D",
      questions: [
        Question(
          description: "Do you use scented tampons, pads or minipads (Y or N)?",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "E",
      questions: [
        Question(
          description: "Do you use a menstrual cup? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "F",
      questions: [
        Question(
          description: "Do you se scented or dyed toilet tissues? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "G",
      questions: [
        Question(
          description: "Do you use fabric softeners in the dryer? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ],[
    FollowUpFormItem(
      section: 5,
      subSection: "H",
      questions: [
        Question(
          description: "Do you use other scented products (e.g. bubble bath, bath oil, etc.)? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "I",
      questions: [
        Question(
          description: "Do you use all-cotton underwear? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "J",
      questions: [
        Question(
          description: "Do you use cotton-crotch panty hose? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "K",
      questions: [
        Question(
          description: "Do you do Breast Self-Exam on day 7 of cycle? (Y or N/\u2714)",
          acceptableInputs: ["Y", "N", "\u2714"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "L",
      questions: [
        Question(
          description: "Do you know when to get a mammogram? (Y or N/\u2714)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "M",
      questions: [
        Question(
          description: "Proper use of tampons explained (if used) (\u2714)",
          acceptableInputs: ["\u2714"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 5,
      subSection: "N",
      questions: [
        Question(
          description: "Review observations with use of menstrual cup (if used) (\u2714)",
          acceptableInputs: ["\u2714"],
        ),
      ],
    ),
  ]
];
const List<List<FollowUpFormItem>> page6Items2 = [
  [
    FollowUpFormItem(
      section: 7,
      subSection: "A",
      questions: [
        Question(
          description: "What is Peak-type mucus?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "B",
      questions: [
        Question(
          description: "What is non-Peak-type mucus?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "C",
      questions: [
        Question(
          description: "What is the Peak Day?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "D",
      questions: [
        Question(
          description: "What is the pre-Peak phase of the cycle?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "E",
      questions: [
        Question(
          description: "What is the post-Peak phase of the cycle?",
        ),
      ],
    ),
  ],
];
const List<List<FollowUpFormItem>> page7Items = [
  [
    FollowUpFormItem(
      section: 8,
      subSection: "A",
      questions: [
        Question(
          description: "CHART REVIEWED WITH FCP/FCPI (\u2714)",
          style: TextStyle(fontWeight: FontWeight.bold),
          acceptableInputs: ["\u2714"],
        )
      ],
    )
  ],[
    FollowUpFormItem(
      section: 8,
      subSection: "B",
      questions: [
        Question(
          description: "Peak Days correctly identified (1,2,\u2714)",
        ),
        Question(
          description: "The Peak Day was confidently identified (Y,N,\u2714)",
          acceptableInputs: ["Y", "N", "\u2714"],
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
          description: "RECORDING SYSTEM (VDRS) REVIEWED (\u2714)",
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
          description: "Discuss concomitant use of barrier methods, coitus interruptus and withdrawal (\u2714)",
        ),
      ],
      disabledCells: {0, 1},
    ),
  ]
];

