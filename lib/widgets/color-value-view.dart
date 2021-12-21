import 'package:colourlovers_app/widgets/color-value-indicator-view.dart';
import 'package:flutter/material.dart';

class ColorValueView extends StatelessWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> trackColors;

  const ColorValueView({
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
          child: Text(label),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ColorValueIndicatorView(
            value: value,
            minValue: minValue,
            maxValue: maxValue,
            trackColors: trackColors,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(value.toInt().toString()),
        ),
      ],
    );
  }
}
