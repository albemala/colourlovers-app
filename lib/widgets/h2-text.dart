import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class H2TextView extends StatelessWidget {
  final String text;

  const H2TextView(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.archivoNarrow(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        letterSpacing: 0.6,
      ),
    );
  }
}
