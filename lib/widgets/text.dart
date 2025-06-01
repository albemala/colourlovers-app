import 'package:colourlovers_app/theme/text.dart';
import 'package:flutter/material.dart';

class H1TextView extends StatelessWidget {
  final String text;

  const H1TextView(this.text, {super.key, });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: getH1TextStyle(context));
  }
}

class H2TextView extends StatelessWidget {
  final String text;

  const H2TextView(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: getH2TextStyle(context));
  }
}
