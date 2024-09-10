import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserView extends StatelessWidget {
  const UserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
          Theme.of(context).colorScheme.primaryContainer, // TODO review colors
      child: Align(
        alignment: Alignment.centerRight, // TODO left?
        child: Padding(
          padding: const EdgeInsets.only(right: 8), // TODO review padding
          child: Icon(
            LucideIcons.userCircle2,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
