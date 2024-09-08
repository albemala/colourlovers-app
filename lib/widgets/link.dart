import 'package:flutter/material.dart';

class LinkView extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const LinkView({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO can I use a text button instead?
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }
}
