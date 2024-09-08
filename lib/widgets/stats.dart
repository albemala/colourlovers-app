import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:flutter/material.dart';

@immutable
class StatsItemViewModel {
  final String label;
  final String value;

  const StatsItemViewModel({
    required this.label,
    required this.value,
  });
}

class StatsView extends StatelessWidget {
  final List<StatsItemViewModel> stats;

  const StatsView({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((entry) {
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextView(entry.label),
            H1TextView(entry.value),
          ],
        );
      }).toList(),
    );
  }
}
