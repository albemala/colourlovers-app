import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class H1TextWidget extends StatelessWidget {
  final String text;
  final Color? color;

  const H1TextWidget(
    this.text, {
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.archivoNarrow(
        textStyle: Theme.of(context).textTheme.headline4,
        color: color ?? Theme.of(context).textTheme.bodyText1?.color,
        letterSpacing: 0.6,
      ),
    );
  }
}
