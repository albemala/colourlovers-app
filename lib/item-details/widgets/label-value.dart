import 'package:colourlovers_app/common/widgets/h1-text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelValueView extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueView({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        H1TextView(
          label.toUpperCase(),
          color: Theme.of(context).colorScheme.tertiary, // TODO review
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: GoogleFonts.archivoNarrow(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              // color: Theme.of(context).textTheme.bodyLarge?.color, // TODO
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}
