
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_item.dart';

import 'comment_section_widget.dart';
import 'fup_form_section_widget.dart';

class FollowUpFormWidget extends StatefulWidget {
  static const String routeName = "fupf";

  const FollowUpFormWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FollowUpFormWidgetState();
}

class _FollowUpFormWidgetState extends State<FollowUpFormWidget> {
  int currentPagePair = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: const EdgeInsets.only(top: 20, left: 20, right: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
          onPressed: currentPagePair > 0 ? () => setState(() {
            currentPagePair--;
          }) : null,
          child: const Text("Previous Page"),
        ),
        Container(),
        ElevatedButton(
          onPressed: currentPagePair < pagePairs.length - 1 ? () => setState(() {
            currentPagePair++;
          }) : null,
          child: const Text("Next Page"),
        ),
      ])),
      Row(children: [
        pagePairs[currentPagePair].leftPage,
        pagePairs[currentPagePair].rightPage,
      ],)
    ]);
  }
}

class PagePair {
  final Widget leftPage;
  final Widget rightPage;

  const PagePair(this.leftPage, this.rightPage);
}

final List<PagePair> pagePairs = [
  PagePair(Page6(), Page7()),
  PagePair(const Page8(), Page9()),
  PagePair(Page10(), Page11()),
];

class Page6 extends AbstractPage {
  Page6({Key? key}) : super(key: key, pageNum: 6, content: [
    const Text("5) HEALTH AND HYGIENE REVIEW (\u2714)", style: sectionHeadingStyle),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page6Items, groupIndex: 0),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page6Items, groupIndex: 1),
    ),
    CommentSectionWidget(numRows: 10, comments: [
      FollowUpFormComment(
        date: DateTime.now(),
        followUpNum: 1,
        sectionNum: 5,
        problem: "A totally not made up problem",
        planOfAction: "A really great and awesome plan",
      ),
    ]),
    Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: FollowUpFormSectionWidget.createSingle(page6Items, groupIndex: 2),
    ),
    const Text("7) DEFINITIONS -- REVIEW & ASSESSMENT", style: sectionHeadingStyle),
    const Text("(Code for this section: 1=Unsatisfactory knowledge  2=Satisfactory knowledge  \u2714=Reviewed - assessment not indicated  -- = Not Applicable)"),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page6Items, groupIndex: 3),
    ),
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
    CommentSectionWidget(numRows: 32, comments: []),
  ]);
}

class Page9 extends AbstractPage {
  Page9({Key? key}) : super(key: key, pageNum: 9, content: [
    const Text("9) SPECIAL DISCHARGES -- REVIEW & ASSESSMENT", style: sectionHeadingStyle),
    const Text("(Code for this section: 1=Unsatisfactory Application  2=Satisfactory Application  \u2714=Reviewed - assessment not indicated  -- = Not Applicable)"),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("A. Arousal Fluid", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: 0),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("What to do", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: 1),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("B. Seminal Fluid", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: 2),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("What to do -- Seminal Fluid Instruction (SFI)", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: 3),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: 4),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Follow-up Questions:", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 10),
          child: FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: 5),
        ),
        FollowUpFormSectionWidget.createSingle(page9Items, groupIndex: page9Items.length - 1, boxSection: true),
      ],
    )),
    const CommentSectionWidget(numRows: 6, comments: []),
  ]);
}

class Page10 extends AbstractPage {
  Page10({Key? key}) : super(key: key, pageNum: 10, content: [
    const Text("10) Charting (NaProTRACKING) PATTERNS IDENTIFIED (\u2714 OR -)", style: sectionHeadingStyle),
    const Text("(All \u2714 require comments)"),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      children: [
        FollowUpFormSectionWidget.createSingle(page10Items, groupIndex: 0),
        FollowUpFormSectionWidget.createSingle(page10Items, groupIndex: 1, boxSection: true),
      ],
    )),
    const CommentSectionWidget(numRows: 16, comments: []),
  ]);
}

class Page11 extends AbstractPage {
  Page11({Key? key}) : super(key: key, pageNum: 11, content: [
    const Text("11) SPECIAL CIRCUMSTANCES -- REVIEW & ASSESSMENT", style: sectionHeadingStyle),
    const Text("(Code for this section: 1=Unsatisfactory Application  2=Satisfactory Application  \u2714=Reviewed - assessment not indicated  -- = Not Applicable)"),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("A. Early Ovulation (occurs in short cycles) (PD)", style: subSectionHeadingStyle,),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("How would you know you are having an early ovulation?", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 0),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("How would you manage an early ovulation?", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 1),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("B. \"Double\" Peak (PD)", style: subSectionHeadingStyle,),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("What is a \"Double\" Peak and when does it occur?", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 2),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 3),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("When should you anticipate a \"Double\" Peak?", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 4),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("How would you manage a \"Double\" Peak?", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 5),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("Discussion Question", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 6),
        ),
        FollowUpFormSectionWidget.createSingle(page11Items, groupIndex: 7, boxSection: true),
      ],
    )),
  ]);
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
const TextStyle subSectionHeadingStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const List<List<FollowUpFormItem>> page6Items = [
  [
    FollowUpFormItem(
      section: 5,
      subSection: "A",
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
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
      disabledCells: {0, 1, 2, 5, 6, 7},
      questions: [
        Question(
          description: "Review observations with use of menstrual cup (if used) (\u2714)",
          acceptableInputs: ["\u2714"],
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 6,
      subSection: "",
      disabledCells: {2, 3, 4, 5, 6, 7},
      questions: [
        Question(
          description: "6) PICTURE DICTIONARY PRESENTED",
          style: sectionHeadingStyle,
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 7,
      subSection: "A",
      disabledCells: {4, 5, 6, 7},
      questions: [
        Question(
          description: "What is Peak-type mucus?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "B",
      disabledCells: {4, 5, 6, 7},
      questions: [
        Question(
          description: "What is non-Peak-type mucus?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "C",
      disabledCells: {4, 5, 6, 7},
      questions: [
        Question(
          description: "What is the Peak Day?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "D",
      disabledCells: {4, 5, 6, 7},
      questions: [
        Question(
          description: "What is the pre-Peak phase of the cycle?",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 7,
      subSection: "E",
      disabledCells: {4, 5, 6, 7},
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

const List<List<FollowUpFormItem>> page9Items = [
  [
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      subSubSection: "1",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "Occurs in response to sexual stimulation (physical or mental)",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      subSubSection: "2",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "Comes from Bartholins glands at the opening of the vagina",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      subSubSection: "3",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "Is designed to facilitate intercourse",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      subSubSection: "4",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "Do you ever notice arousal fluid? (Y or N)\n(If yes, record her description in comments section)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      subSubSection: "5",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "If confident that fluid is arousal fluid, then it may be ignored",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      subSubSection: "6",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "If ever uncertain, consider it fertile and observe it on its merits",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      subSubSection: "1",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "Seminal fluid becomes a discharge following intercourse",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      subSubSection: "2",
      disabledCells: {0, 4, 6, 7},
      questions: [
        Question(
          description: "Employ seminal fluid instruction in order to prevent confusion, bladder infections, and the discomfort\nof an additional discharge",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      subSubSection: "3",
      disabledCells: {0},
      questions: [
        Question(
          description: "Urinate after intercourse (within 1 hour)",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      subSubSection: "4",
      disabledCells: {0},
      questions: [
        Question(
          description: "Bear down and do several Kegel's exercises in an alternating fashion\nExplain Kegel's exercises (\u2714)",
        ),
      ],
    ),
  ],[
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      subSubSection: "5",
      disabledCells: {0},
      questions: [
        Question(
          description: "Wipe until the SF is gone",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      subSubSection: "6",
      disabledCells: {0},
      questions: [
        Question(
          description: "Observe all discharges after the SFI on its merits",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 9,
      subSection: "A",
      disabledCells: {0, 1},
      questions: [
        Question(
          description: "Are you using the SFI? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
        Question(
          description: "# of sets of Kegel's & BD",
          acceptableInputs: [],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 9,
      subSection: "B",
      disabledCells: {0, 1},
      questions: [
        Question(
          description: "Do you see a discharge the next day? (Y or N)\nIf yes, describe discharge, frequency and POA in comments",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 9,
      subSection: "C",
      questions: [
        Question(
          description: "SECTION 9: IS MANAGEMENT OF SPECIAL DISCHARGES NECESSARY? (Y or N)",
          style: TextStyle(fontWeight: FontWeight.bold),
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ]
];

const List<List<FollowUpFormItem>> page10Items = [
  [
    FollowUpFormItem(
      section: 10,
      subSection: "A",
      questions: [
        Question(
          description: "Over-reading lubrication",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "B",
      questions: [
        Question(
          description: "Continuous mucus",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "C",
      questions: [
        Question(
          description: "Mucus cycle > 8 days (reg. cycles)",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "D",
      questions: [
        Question(
          description: "Variable return of Peak-type mucus",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "E",
      questions: [
        Question(
          description: "Post-Peak, non-Peak-type mucus",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "F",
      questions: [
        Question(
          description: "Post-Peak pasty",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "G",
      questions: [
        Question(
          description: "Post-Peak, Peak-type mucus",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "H",
      questions: [
        Question(
          description: "Premenstrual spotting",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "I",
      questions: [
        Question(
          description: "Unusual bleeding",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "J",
      questions: [
        Question(
          description: "Limited mucus",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 10,
      subSection: "K",
      questions: [
        Question(
          description: "Other (i.e. TEBB)",
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 10,
      subSection: "L",
      questions: [
        Question(
          description: "SECTION 10: IS MANAGEMENT OF CHARTING PATTERN NECESSARY? (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ]
];

const List<List<FollowUpFormItem>> page11Items = [
  [
    FollowUpFormItem(
      section: 11,
      subSection: "A",
      subSubSection: "1",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Mucus can be present during the menstrual flow",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "A",
      subSubSection: "2",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Ovulation may occur early in the cycle",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 11,
      subSection: "A",
      subSubSection: "3",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Observe for mucus/dryness on L, VL, or B days of flow",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 11,
      subSection: "B",
      subSubSection: "1",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Occurs principally in response to stress (acute vs. chronic)",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 11,
      subSection: "B",
      subSubSection: "2",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Can be physical or emotional, positive or negative (e.g. sickness, strenuous activity, change of job,\nmoving, bereavement, major decisions, holidays, relatives visiting, travel, weddings, exams, etc.)",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "3",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "The stress delays ovulation",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "4",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "The \"second\" peak generally occurs after the stress is relieved",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "5",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Ovulation occurs with the \"second\" peak",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "6",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "It can happen to any woman",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "7",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "It may be a protective mechanism at work",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "8",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Be aware of current or approaching stress",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "9",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "When peak buildup or Peak Day appears unusual",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "10",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "When you are 16 days or more post-peak (missed period)",
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "11",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "If \"Double\" Peak anticipated, follow pre-peak, end of the day instruction until the situation is clarified",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "12",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Wife monitors peak buildup or if Peak Day is unsual",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "13",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Husband monitors stress awareness",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "14",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Ask yourself and your spouse the \"Double\" Peak questions on P + 3",
        ),
      ],
    ),
    FollowUpFormItem(
      section: 11,
      subSection: "C",
      subSubSection: "15",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Are you asking the \"Double\" Peak Question (Y or N)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 11,
      subSection: "Q",
      disabledCells: {0, 1, 5, 6, 7},
      questions: [
        Question(
          description: "Are you under stress now or anticipating any stressful time in the near future? (Y or N)\n(If yes, comment required)",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ], [
    FollowUpFormItem(
        section: 11,
        subSection: "C",
        questions: [
          Question(
            description: "SECTION 11: IS MANAGEMENT OF SPECIAL CIRCUMSTANCES NECESSARY? (Y or N)",
            acceptableInputs: ["Y", "N"],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
  ]
];
