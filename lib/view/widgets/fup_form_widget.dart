
import 'package:flutter/material.dart';
import 'package:fmfu/model/fup_form_layout.dart';

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
  PagePair(Page2(), Page3()),
  PagePair(Page4(), Page5()),
  PagePair(Page6(), Page7()),
  PagePair(Page8(), Page9()),
  PagePair(Page10(), Page11()),
  PagePair(Page22(), Page23()),
];

final Widget comingSoon = Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
  Center(child: Text("Coming Soon!")),
],));

class Page2 extends AbstractPage {
  Page2({Key? key}) : super(key: key, pageNum: 2, content: [
    const Text("COMPLETION OF FORMS", style: sectionHeadingStyle),
    comingSoon, // TODO: finish
  ]);
}

class Page3 extends AbstractPage {
  Page3({Key? key}) : super(key: key, pageNum: 3, content: [
    const Text("4) OBSERVATIONS", style: sectionHeadingStyle),
    const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text("How do you check for the mucus?", style: subSectionHeadingStyle,),
    ),
    Padding(
      padding: const EdgeInsets.all(10),
      child: FollowUpFormSectionWidget.createSingle(
        page3Items, groupIndex: 0,
        explanationSectionTitle: "Reason for Observational Routine Explained\n(First FU -- \u2714 when reviewed)",
      ),
    ),
    AbstractPage.getCommentSection(3),
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
    AbstractPage.getCommentSection(4),
  ]);
}

class Page5 extends AbstractPage {
  Page5({Key? key}) : super(key: key, pageNum: 5, content: [
    const Text("4) OBSERVATIONS -- Cont'd", style: sectionHeadingStyle),
    Expanded(child: Row(children: [
      const RotatedBox(
        quarterTurns: 3,
        child: Text("Reason for Observational Routine Explained\n(First FU -- \u2714 when reviewed)", textAlign: TextAlign.center,),
      ),
      Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text("The Three Steps", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FollowUpFormSectionWidget.createSingle(
            page5Items, groupIndex: 0,
            explanationSectionTitle: "",
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("X. SPECIAL INSTRUCTIONS", style: subSectionHeadingStyle,),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FollowUpFormSectionWidget.createSingle(
            page5Items, groupIndex: 1,
            explanationSectionTitle: "",
          ),
        ),
      ])),
    ])),
    FollowUpFormSectionWidget.createSingle(page5Items, groupIndex: 2, boxSection: true),
    AbstractPage.getCommentSection(5),
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
    AbstractPage.getCommentSection(6),
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
    AbstractPage.getCommentSection(7),
  ]);
}

class Page8 extends AbstractPage {
  Page8({Key? key}) : super(key: key, pageNum: 8, content: [
    AbstractPage.getCommentSection(8),
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
    AbstractPage.getCommentSection(9),
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
    AbstractPage.getCommentSection(10),
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

class Page12 extends AbstractPage {
  Page12({Key? key}) : super(key: key, pageNum: 12, content: [
    AbstractPage.getCommentSection(12),
    comingSoon, // TODO: finish
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
        AbstractPage.getCommentSection(23),
      ],
    ))
  ]);
}

const pageTitleStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);

abstract class AbstractPage extends StatelessWidget {
  static const double pageWidth = 1000;

  final int pageNum;
  final List<Widget> content;

  const AbstractPage({Key? key, required this.content, required this.pageNum}) : super(key: key);

  static CommentSectionWidget getCommentSection(int pageNum) {
    return CommentSectionWidget(pageNum: pageNum);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 1150, width: pageWidth, child: Padding(padding: const EdgeInsets.all(20), child: Column(
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

