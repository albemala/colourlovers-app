import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelValueView extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueView({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return Container();
    return Row(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          // maxLines: 1,
          // overflow: TextOverflow.fade,
          // softWrap: false,
          style: GoogleFonts.archivoNarrow(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            color: Theme.of(context).colorScheme.tertiary, // TODO review
            // color: Theme.of(context).textTheme.bodyLarge?.color, // TODO
            // letterSpacing: 0.6,
          ),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: GoogleFonts.archivo(
              textStyle: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w100),
              // color: Theme.of(context).colorScheme.tertiary, // TODO review
              // color: color, // TODO ?? Theme.of(context).textTheme.bodyLarge?.color,
              // letterSpacing: -0.6,
            ),
          ),
        ),
      ],
    );
  }
}
