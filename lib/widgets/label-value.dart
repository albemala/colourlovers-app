import 'package:colourlovers_app/theme/text.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';

class LabelValueView extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueView({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2TextView(label),
        Text(value, style: getValueTextStyle(context)),
      ],
    );
  }
}
