import 'package:colourlovers_app/widgets/color-channel-track.dart';
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
      spacing: 8,
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
        Expanded(
          child: ColorChannelTrackView(
            value: value,
            minValue: minValue,
            maxValue: maxValue,
            trackColors: trackColors,
          ),
        ),
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
