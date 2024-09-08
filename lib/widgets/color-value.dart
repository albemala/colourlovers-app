import 'package:colourlovers_app/widgets/color-value-indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorChannelView extends StatelessWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> trackColors;

  const ColorChannelView({
    super.key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.trackColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 12,
          child: Text(
            label,
            style: GoogleFonts.archivoNarrow(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              letterSpacing: 0.6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ColorChannelValueView(
            value: value,
            minValue: minValue,
            maxValue: maxValue,
            trackColors: trackColors,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            value.toInt().toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
