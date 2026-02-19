import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                LucideIcons.userCircle2,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
