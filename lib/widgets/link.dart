import 'package:flutter/material.dart';

class LinkWidget extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const LinkWidget({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }
}
