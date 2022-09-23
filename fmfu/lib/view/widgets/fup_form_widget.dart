
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_comment.dart';
import 'package:fmfu/model/fup_form_item.dart';
import 'package:fmfu/model/instructions.dart';

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
  PagePair(Page4(), Page5()),
  PagePair(Page6(), Page7()),
  PagePair(const Page8(), Page9()),
  PagePair(Page10(), Page11()),
  PagePair(Page22(), Page23()),
];

class Page3 extends AbstractPage {
  Page3({Key? key}) : super(key: key, pageNum: 4, content: [
    const Text("4) OBSERVATIONS", style: sectionHeadingStyle),
    const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text("How do you check for the mucus?", style: subSectionHeadingStyle,),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page3Items, groupIndex: 0),
    ),
  ]);
}

class Page4 extends AbstractPage {
  Page4({Key? key}) : super(key: key, pageNum: 4, content: [
    const Text("4) OBSERVATIONS -- Cont'd", style: sectionHeadingStyle),
    const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text("When do you check for the mucus?", style: subSectionHeadingStyle,),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(
        page4Items, groupIndex: 0,
        explanationSectionTitle: "Reason for Observational Routine Explained\n(First FU -- \u2714 when reviewed)",),
    ),
    const CommentSectionWidget(numRows: 17, previousSection: 4),
  ]);
}

class Page5 extends AbstractPage {
  Page5({Key? key}) : super(key: key, pageNum: 5, content: [
    const Text("4) OBSERVATIONS -- Cont'd", style: sectionHeadingStyle),
    const Padding(
      padding: EdgeInsets.only(left: 20, top: 20),
      child: Text("The Three Steps", style: subSectionHeadingStyle,),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(
        page5Items, groupIndex: 0,
        explanationSectionTitle: "Reason for Observational Routine Explained\n(First FU -- \u2714 when reviewed)",
      ),
    ),
    const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text("X. SPECIAL INSTRUCTIONS", style: subSectionHeadingStyle,),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page5Items, groupIndex: 1),
    ),
    FollowUpFormSectionWidget.createSingle(page5Items, groupIndex: 2, boxSection: true),
    const CommentSectionWidget(numRows: 16, previousSection: 4),
  ]);
}

class Page6 extends AbstractPage {
  Page6({Key? key}) : super(key: key, pageNum: 6, content: [
    const Text("5) HEALTH AND HYGIENE REVIEW (\u2714)", style: sectionHeadingStyle),
    // TODO: add principles explained column
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page6Items, groupIndex: 0),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(page6Items, groupIndex: 1),
    ),
    const CommentSectionWidget(numRows: 10, previousSection: 5),
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
    const CommentSectionWidget(numRows: 16, previousSection: 8),
  ]);
}

class Page8 extends AbstractPage {
  const Page8({Key? key}) : super(key: key, pageNum: 8, content: const [
    CommentSectionWidget(numRows: 32, previousSection: 8),
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
    const CommentSectionWidget(numRows: 6, previousSection: 9,),
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
    const CommentSectionWidget(numRows: 16, previousSection: 10),
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

class Page22 extends AbstractPage {
  Page22({Key? key}) : super(key: key, pageNum: 22, content: [
    const Text("14) INSTRUCTIONS -- LIST AND INTEGRATION (\u2714 OR --)", style: sectionHeadingStyle),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("I. LIST", style: sectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 0),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("D. Days of fertility (Select to achieve pregnancy)"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 1),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("E. Days of infertility (Select to avoid pregnancy)"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 2),
        ),
        Padding( // F
          padding: const EdgeInsets.only(left: 20),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 3),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("G. \"Double\" Peak"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 4),
        ),
        Padding( // H
          padding: const EdgeInsets.only(left: 20),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 5),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("I. Special Fertility Instructions (Subfertility clients only)"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page22Items, groupIndex: 6),
        ),
      ],
    ))
  ]);
}

class Page23 extends AbstractPage {
  Page23({Key? key}) : super(key: key, pageNum: 23, content: [
    const Text("14) INSTRUCTIONS -- Cont'd", style: sectionHeadingStyle),
    Padding(padding: const EdgeInsets.all(10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 0),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("K. Yellow Stamp Instructions"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 1),
        ),
        Padding( // F
          padding: const EdgeInsets.only(left: 20),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 2),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Some random extra questions...", style: TextStyle(fontStyle: FontStyle.italic),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 3),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 4, boxSection: true),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("II. INSTRUCTION INTEGRATION (Y or N)", style: sectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 5),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: FollowUpFormSectionWidget.createSingle(page23Items, groupIndex: 6, boxSection: true),
        ),
        const CommentSectionWidget(numRows: 5, previousSection: 14),
      ],
    ))
  ]);
}

abstract class AbstractPage extends StatelessWidget {
  static const double pageWidth = 1000;

  final int pageNum;
  final List<Widget> content;

  const AbstractPage({Key? key, required this.pageNum, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
const List<List<FollowUpFormItem>> page3Items = [
  [
    FollowUpFormItem(
      section: 4,
      subSection: "A",
      questions: [
        Question(
          description: "Do you use flat layers of tissue?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "B",
      questions: [
        Question(
          description: "Do you ever use crumpled tissue?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "C",
      questions: [
        Question(
          description: "Do you wipe from back to front (1) or ffrom front to back (2)",
          acceptableInputs: ["1", "2"],
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "D",
      questions: [
        Question(
          description: "Do you check from the urethra thru the the perineal body?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "E",
      questions: [
        Question(
          description: "Do you always wipe until the mucus is gone?",
        ),
        Question(
          description: "Until dry?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "F",
      questions: [
        Question(
          description: "Do you ever do internal examinations to check for the mucus?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "G",
      questions: [
        Question(
          description: "Do you ever check directly with your fingers?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "H",
      questions: [
        Question(
          description: "Do you ever base your observations on what you may see on your underwear?",
        )
      ],
    ),
  ],
];
const List<List<FollowUpFormItem>> page4Items = [
  [
    FollowUpFormItem(
      section: 4,
      subSection: "I",
      questions: [
        Question(
          description: "Do you check every time before urination?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "J",
      questions: [
        Question(
          description: "Do you check every time after urination?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "K",
      questions: [
        Question(
          description: "Do you check every time before a bowel movement?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "L",
      questions: [
        Question(
          description: "Do you check every time after a bowel movement?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "M",
      questions: [
        Question(
          description: "Is there ever a time when you go to the bathroom but do not check?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "N",
      questions: [
        Question(
          description: "Do you check every time before going to bed?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "O",
      questions: [
        Question(
          description: "Do you bear down every time before going to bed? (within 15 min.)",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "P",
      questions: [
        Question(
          description: "Do you make a decision at each observation?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "Q",
      questions: [
        Question(
          description: "Do you register that observation?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "R",
      questions: [
        Question(
          description: "Do you ever discontinue your observations?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "S",
      questions: [
        Question(
          description: "Do you ever get complacent about your observations?",
        )
      ],
    ),
  ],
];
const List<List<FollowUpFormItem>> page5Items = [
  [
    FollowUpFormItem(
      section: 4,
      subSection: "T",
      questions: [
        Question(
          description: "Can you tell me what are the three steps in checking for the mucus?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "U",
      questions: [
        Question(
          description: "Do you always determine the sensation when wiping before observing the tissue?",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "V",
      questions: [
        Question(
          description: "Do you always finger test anything you see on the tissue? (including 2, 2W, 4)",
        )
      ],
    ),
    FollowUpFormItem(
      section: 4,
      subSection: "W",
      questions: [
        Question(
          description: "What observations do you make when finger testing?",
        )
      ],
    ),
  ], [
    FollowUpFormItem(
      section: 4,
      subSection: "X",
      subSubSection: "1",
      disabledCells: {1, 2, 3, 5, 6},
      questions: [
        Question(
          description: "How often do you have a bowel movement? (# of times / day)",
          acceptableInputs: [],
        ),
        Question(
          description: "(# of days / week)",
          acceptableInputs: [],
        ),
      ]),
    FollowUpFormItem(
        section: 4,
        subSection: "X",
        subSubSection: "2",
        disabledCells: {1, 2, 3, 5, 6},
        questions: [
          Question(
            description: "How often do you get up at night to urinate? (# of times)",
            acceptableInputs: [],
          ),
          Question(
            description: "Do you observe at that time? (Y, N, \u2714)",
            acceptableInputs: ["Y", "N", "\u2714"],
          ),
        ]),
    FollowUpFormItem(
        section: 4,
        subSection: "X",
        subSubSection: "3",
        disabledCells: {1, 2, 3, 5, 6},
        questions: [
          Question(
            description: "Do you generally take baths(1), showers(2), or both(3)?",
            acceptableInputs: ["1", "2", "3"],
          ),
          Question(
            description: "Do you check before and after? (Y or N)",
            acceptableInputs: ["Y", "N"],
          ),
        ]),
    FollowUpFormItem(
        section: 4,
        subSection: "X",
        subSubSection: "4",
        disabledCells: {1, 2, 3, 5, 6},
        questions: [
          Question(
            description: "How often do you go swimming? (# of times)",
            acceptableInputs: [],
          ),
          Question(
            description: "Do you check before and after? (Y, N, \u2714)",
            acceptableInputs: ["Y", "N", "\u2714"],
          ),
        ]),
  ], [
    FollowUpFormItem(
      section: 4,
      subSection: "Y",
      questions: [
        Question(
          description: "SECTION 4: IS MANAGEMENT OF OBSERVATIONS NECESSARY? (Y or N)",
          style: TextStyle(fontWeight: FontWeight.bold),
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ]
];
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
          acceptableInputs: ["1", "2", "\u2714"]
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
          description: "Do you ever notice arousal fluid? (Y or N) (If yes, record her description in comments section)",
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
          description: "Employ seminal fluid instruction in order to prevent confusion, bladder infections, and the discomfort of an additional discharge",
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
          description: "Bear down and do several Kegel's exercises in an alternating fashion Explain Kegel's exercises (\u2714)",
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
          description: "Do you see a discharge the next day? (Y or N) If yes, describe discharge, frequency and POA in comments",
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
          description: "Can be physical or emotional, positive or negative (e.g. sickness, strenuous activity, change of job, moving, bereavement, major decisions, holidays, relatives visiting, travel, weddings, exams, etc.)",
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
          description: "Are you under stress now or anticipating any stressful time in the near future? (Y or N) (If yes, comment required)",
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
          ),
        ]),
  ]
];

final List<List<FollowUpFormItem>> page22Items = [
  [ // 0
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "A",
      questions: [
        Question(
          description: Instruction.a.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "B",
      questions: [
        Question(
          description: Instruction.b.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "C",
      questions: [
        Question(
          description: Instruction.c.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ],[ // 1
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "D",
      subSubSection: "1",
      questions: [
        Question(
          description: Instruction.d1.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "D",
      subSubSection: "2",
      questions: [
        Question(
          description: Instruction.d2.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "D",
      subSubSection: "3",
      questions: [
        Question(
          description: Instruction.d3.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "D",
      subSubSection: "4",
      questions: [
        Question(
          description: Instruction.d4.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "D",
      subSubSection: "5",
      questions: [
        Question(
          description: Instruction.d5.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "D",
      subSubSection: "6",
      questions: [
        Question(
          description: Instruction.d6.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ //2
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "1",
      questions: [
        Question(
          description: Instruction.e1.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "2",
      questions: [
        Question(
          description: Instruction.e2.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "3",
      questions: [
        Question(
          description: Instruction.e3.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "4",
      questions: [
        Question(
          description: Instruction.e4.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "5",
      questions: [
        Question(
          description: Instruction.e5.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "6",
      questions: [
        Question(
          description: Instruction.e6.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "E",
      subSubSection: "7",
      questions: [
        Question(
          description: Instruction.e7.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ // 3
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "F",
      questions: [
        Question(
          description: Instruction.f.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ // 4
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "G",
      subSubSection: "1",
      questions: [
        Question(
          description: Instruction.g1.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "G",
      subSubSection: "2",
      questions: [
        Question(
          description: Instruction.g2.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "G",
      subSubSection: "3",
      questions: [
        Question(
          description: Instruction.g3.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ // 5
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "H",
      questions: [
        Question(
          description: Instruction.h.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ // 6
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "I",
      subSubSection: "1",
      questions: [
        Question(
          description: Instruction.i1.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "I",
      subSubSection: "2",
      questions: [
        Question(
          description: Instruction.i2.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "I",
      subSubSection: "3",
      questions: [
        Question(
          description: Instruction.i3.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "I",
      subSubSection: "4",
      questions: [
        Question(
          description: Instruction.i4.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ]
];

final List<List<FollowUpFormItem>> page23Items = [
  [ // 0
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "J",
      questions: [
        Question(
          description: Instruction.j.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ // 1
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "K",
      subSubSection: "1",
      questions: [
        Question(
          description: Instruction.k1.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "K",
      subSubSection: "2",
      questions: [
        Question(
          description: Instruction.k2.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "K",
      subSubSection: "3",
      questions: [
        Question(
          description: Instruction.k3.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "K",
      subSubSection: "4",
      questions: [
        Question(
          description: Instruction.k4.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "K",
      subSubSection: "5",
      questions: [
        Question(
          description: Instruction.k5.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "K",
      subSubSection: "6",
      questions: [
        Question(
          description: Instruction.k6.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [ // 2
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "L",
      questions: [
        Question(
          description: Instruction.l.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "M",
      questions: [
        Question(
          description: Instruction.m.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "N",
      questions: [
        Question(
          description: Instruction.n.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
    FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "O",
      questions: [
        Question(
          description: Instruction.o.description,
          acceptableInputs: ["\u2714", "-"],
        ),
      ],
    ),
  ], [
    const FollowUpFormItem(
      section: 14,
      superSection: "I",
      // What even is this code...
      subSection: "",
      subSubSection: "1",
      questions: [
        Question(
          description: "Can you define the \"end of day\"?",
          acceptableInputs: ["1", "2"],
        ),
      ],
    ),
    const FollowUpFormItem(
      section: 14,
      superSection: "I",
      // What even is this code...
      subSection: "",
      subSubSection: "2",
      questions: [
        Question(
          description: "Achieving-related and avoiding-related use of the system discussed.",
          acceptableInputs: ["\u2714"],
        ),
        Question(
          description: "Exhibits understanding of achieving-related and avoiding-related use.",
          acceptableInputs: ["1", "2"],
        ),
      ],
    ),
  ], [
    const FollowUpFormItem(
      section: 14,
      superSection: "I",
      subSection: "Q",
      questions: [
        Question(
          description: "SECTION 14-I: IS MANAGEMENT OF INSTRUCTIONS LIST NECESSARY? (Y or N)",
          style: TextStyle(fontWeight: FontWeight.bold),
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ], [
    const FollowUpFormItem(
      section: 14,
      superSection: "II",
      subSection: "A",
      questions: [
        Question(
          description: "Client demonstrates understanding of basic system instructions",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
    const FollowUpFormItem(
      section: 14,
      superSection: "II",
      subSection: "A",
      questions: [
        Question(
          description: "Client demonstrates understanding of their system instructions",
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ], [
    const FollowUpFormItem(
      section: 14,
      superSection: "II",
      subSection: "C",
      questions: [
        Question(
          description: "SECTION 14-II: IS MANAGEMENT OF INSTRUCTION INTEGRATION NECESSARY? (Y or N)",
          style: TextStyle(fontWeight: FontWeight.bold),
          acceptableInputs: ["Y", "N"],
        ),
      ],
    ),
  ]
];
