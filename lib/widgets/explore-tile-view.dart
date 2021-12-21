import 'package:flutter/material.dart';

class ExploreTileView extends StatelessWidget {
  final void Function() onTap;
  final String text;

  const ExploreTileView({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(text),
        ),
      ),
    );
  }
}
