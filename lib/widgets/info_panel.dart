import 'package:flutter/material.dart';

class ExpandableInfoPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> contents;
  final Widget? trailing;
  final bool initiallyExpanded;
  final double childrenHorizontalPadding;
  final TextStyle? titleStyle;

  const ExpandableInfoPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.contents,
    this.trailing,
    this.initiallyExpanded = false,
    this.childrenHorizontalPadding = 20,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(child: ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(title, style: titleStyle ?? Theme.of(context).textTheme.titleLarge),
      subtitle: subtitle == "" ? null : Text(subtitle),
      childrenPadding: EdgeInsets.symmetric(horizontal: childrenHorizontalPadding),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.topLeft,
      trailing: trailing,
      children: contents,
    ));
  }
}

class InfoPanel extends StatelessWidget {
  final String title;
  final List<Widget> contents;

  const InfoPanel({super.key, required this.title, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        ...contents.map((w) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: w)),
      ],
    )));
  }
}

class InfoItem extends StatelessWidget {
  final String itemName;
  final Widget itemValue;

  const InfoItem({super.key, required this.itemName, required this.itemValue});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(2), child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("$itemName:", style: Theme.of(context).textTheme.titleMedium?.apply(fontWeightDelta: 2)),
        Container(width: 4),
        itemValue,
      ],
    ));

  }
}
