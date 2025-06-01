import 'package:colourlovers_app/theme/text.dart';
import 'package:flutter/material.dart';

class LinkView extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const LinkView({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Text(text, style: getLinkTextStyle(context)),
      ),
    );
  }
}
