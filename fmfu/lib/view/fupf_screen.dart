import 'package:flutter/material.dart';
import 'package:fmfu/view/widgets/box_grid_widget.dart';

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
        Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          title("A", "CHART REVIEWED WITH FCP/FCPI (X)", style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          BoxGridWidget(
            rows: [
              GridRow("8A"),
            ],
          ),
        ]),
        IntrinsicHeight(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(padding: EdgeInsets.only(top: 5), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
            title("B", "Peak Days correctly identified (1,2,X) \n The Peak Day was confidentally identified (Y,N,X)"),
            title("C", "Correctly charts stamps"),
            title("D", "Correctly charts recording system"),
            title("", "RECORDING SYSTEM (VDRS) REVIEWED (X)", style: TextStyle(fontWeight: FontWeight.bold)),
            title("E", "Charts at the end of teh day / Who does the charting? (M, W, B)"),
            title("F", "Charts the most fertile sign of the day"),
            title("G", "Charts the menstrual flow -- H, M, L, VL, B"),
            title("H", "Charts brow/black bleeding as B"),
            title("I", "Charts bleeding other than the period"),
            title("J", "Charts dry/mucus on L, VL, and B days"),
            title("K", "Charts all acts of intercourse -- I"),
            title("L", "Charts discharge after intercourse on its merits"),
            title("M", "Are barrier methods being used? (Y or N)"),
            title("N", "Is coitus interruptus or withdrawal being used? (Y or N)"),
            title("O", "Discuss concomitant use of barrier methods, coitus interruptus and withdrawal (X)"),
          ])),
          Spacer(),
          BoxGridWidget(
            rows: [
              GridRow("8B", splitCells: true),
              GridRow("8C"),
              GridRow("8D"),
              GridRow("", disabledCells: {2, 3, 4, 5, 6, 7}),
              GridRow("8E", splitCells: true),
              GridRow("8F"),
              GridRow("8G"),
              GridRow("8H"),
              GridRow("8I"),
              GridRow("8J"),
              GridRow("8K"),
              GridRow("8L"),
              GridRow("8M", disabledCells: {0, 1}),
              GridRow("8N", disabledCells: {0, 1}),
              GridRow("8O", disabledCells: {0, 1}),
            ],
          )
        ])),
        Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey, border: Border.all(width: 2.0)),
            child: Padding(padding: EdgeInsets.all(4), child: title("P", "SECTION 8: IS MANAGEMENT OF CHARTING NECESSARY? (Y or N)", style: TextStyle(fontWeight: FontWeight.bold))),
          ),
          Spacer(),
          BoxGridWidget(
            rows: [
              GridRow("8A"),
            ],
          ),
        ]),
      ]))),
    ])));
    /*return SizedBox(height: 2000, width: 1000, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          )),
        ]),
      ]))),
    ])));*/
  }

}
