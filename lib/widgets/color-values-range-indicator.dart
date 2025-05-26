import 'package:flutter/material.dart';

class ColorValueRangeIndicatorView extends StatelessWidget {
  final double min;
  final double max;
  final double lowerValue;
  final double upperValue;
  final Color Function(double) getColor;

  const ColorValueRangeIndicatorView({
    super.key,
    required this.min,
    required this.max,
    required this.lowerValue,
    required this.upperValue,
    required this.getColor,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(6));
    return Container(
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: 1,
        ),
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CustomPaint(
          size: const Size.fromHeight(22),
          painter: _ColorRangePainter(
            context: context,
            min: min,
            max: max,
            lowerValue: lowerValue,
            upperValue: upperValue,
            getColor: getColor,
          ),
        ),
      ),
    );
  }
}

class _ColorRangePainter extends CustomPainter {
  final BuildContext context;
  final double min;
  final double max;
  final double lowerValue;
  final double upperValue;
  final Color Function(double) getColor;

  _ColorRangePainter({
    required this.context,
    required this.min,
    required this.max,
    required this.lowerValue,
    required this.upperValue,
    required this.getColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final backgroundColor = Theme.of(context).colorScheme.surface;
    final width = size.width.toInt();
    final height = size.height;
    final range = max - min;

    for (var x = 0; x < width; x++) {
      final currentValue = min + (x / width) * range;
      paint.color =
          (currentValue >= lowerValue && currentValue <= upperValue)
              ? getColor(currentValue)
              : backgroundColor;
      canvas.drawRect(Rect.fromLTWH(x.toDouble(), 0, 1, height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
