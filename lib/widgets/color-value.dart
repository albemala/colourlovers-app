import 'package:colourlovers_app/widgets/color-value-indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorValueWidget extends StatelessWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> trackColors;

  const ColorValueWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.trackColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 12,
          child: Text(
            label,
            style: GoogleFonts.archivoNarrow(
              textStyle: Theme.of(context).textTheme.bodyText2,
              letterSpacing: 0.6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ColorValueIndicatorWidget(
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
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}
