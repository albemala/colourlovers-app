import 'package:colourlovers_app/theme/text.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';

@immutable
class StatsItemViewState {
  final String label;
  final String value;

  const StatsItemViewState({required this.label, required this.value});
}

class StatsView extends StatelessWidget {
  final List<StatsItemViewState> stats;

  const StatsView({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          stats.map((entry) {
            return Column(
              children: [
                H2TextView(entry.label),
                Text(entry.value, style: getValueTextStyle(context)),
              ],
            );
          }).toList(),
    );
  }
}
