import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final Map<String, String> stats;

  const StatsWidget({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.entries.map((entry) {
        final title = entry.key;
        final value = entry.value;
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextWidget(title),
            H1TextWidget(value),
          ],
        );
      }).toList(),
    );
  }
}
