import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class H2TextWidget extends StatelessWidget {
  final String text;

  const H2TextWidget(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.archivoNarrow(
        textStyle: Theme.of(context).textTheme.bodyText2,
        letterSpacing: 0.6,
      ),
    );
  }
}
