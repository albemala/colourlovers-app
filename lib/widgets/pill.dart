import 'package:colourlovers_app/theme/text.dart';
import 'package:flutter/material.dart';

class PillView extends StatelessWidget {
  final String text;
  final IconData icon;

  const PillView({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          const SizedBox(width: 8),
          Text(text, style: getPillTextStyle(context)),
        ],
      ),
    );
  }
}
