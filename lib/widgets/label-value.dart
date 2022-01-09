import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelValueWidget extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        H1TextWidget(
          label.toUpperCase(),
          color: const Color(0xFF8B5CF6),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: GoogleFonts.archivoNarrow(
              textStyle: Theme.of(context).textTheme.headline4,
              color: Theme.of(context).textTheme.bodyText1?.color,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}
