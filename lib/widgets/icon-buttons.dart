import 'dart:io';

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
      icon: const Icon(LucideIcons.sparkles),
    );
  }
}

class ShareItemButton extends StatelessWidget {
  final void Function() onPressed;

  const ShareItemButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Platform.isIOS || Platform.isMacOS
            ? LucideIcons.share
            : LucideIcons.share2,
      ),
    );
  }
}
