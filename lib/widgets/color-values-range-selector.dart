import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:colourlovers_app/formatters.dart';
import 'package:colourlovers_app/theme/text.dart';
import 'package:flutter/material.dart';

class ColorValueRangeSelectorView extends StatelessWidget {
  final double min;
  final double max;
  final double lowerValue;
  final double upperValue;
  final void Function(double, double) onChanged;
  final Color Function(double) getColor;

  const ColorValueRangeSelectorView({
    super.key,
    required this.min,
    required this.max,
    required this.lowerValue,
    required this.upperValue,
    required this.onChanged,
    required this.getColor,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      rangeSlider: true,
      min: min,
      max: max,
      values: [lowerValue, upperValue],
      onDragging: (handlerIndex, lowerValue, upperValue) {
        onChanged(lowerValue as double, upperValue as double);
      },
      handlerWidth: 24,
      handler: buildFlutterSliderHandler(context, color: getColor(lowerValue)),
      rightHandler: buildFlutterSliderHandler(
        context,
        color: getColor(upperValue),
      ),
      trackBar: buildFlutterSliderTrackBar(
        context,
        colors: List.generate(
          (upperValue - lowerValue).toInt(),
          (index) => getColor(lowerValue + index),
        ),
      ),
      tooltip: buildFlutterSliderTooltip(context),
    );
  }
}

FlutterSliderHandler buildFlutterSliderHandler(
  BuildContext context, {
  required Color color,
}) {
  return FlutterSliderHandler(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(
        color: Theme.of(context).colorScheme.surface,
        width: 4,
      ),
    ),
    child: Container(),
  );
}

FlutterSliderTrackBar buildFlutterSliderTrackBar(
  BuildContext context, {
  required List<Color> colors,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final borderRadius = BorderRadius.circular(6);
  final border = Border.all(color: colorScheme.onSurface);
  return FlutterSliderTrackBar(
    activeTrackBarHeight: 12,
    activeTrackBar: BoxDecoration(
      gradient: colors.length > 2 ? LinearGradient(colors: colors) : null,
      border: border,
      borderRadius: borderRadius,
    ),
    inactiveTrackBarHeight: 12,
    inactiveTrackBar: BoxDecoration(
      color: colorScheme.surface,
      border: border,
      borderRadius: borderRadius,
    ),
  );
}

FlutterSliderTooltip buildFlutterSliderTooltip(BuildContext context) {
  return FlutterSliderTooltip(
    textStyle: getColorValueTextStyle(context),
    boxStyle: FlutterSliderTooltipBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(32),
      ),
    ),
    format: (value) {
      return value.toIntString();
    },
  );
}
