import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RandomItemButton extends StatelessWidget {
  final void Function() onPressed;
  final String tooltip;

  const RandomItemButton({
    super.key,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: const Icon(
        LucideIcons.sparkles,
      ),
    );
  }
}
