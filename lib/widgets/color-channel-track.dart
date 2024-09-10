import 'package:flutter/material.dart';

class ColorChannelTrackView extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> trackColors;

  const ColorChannelTrackView({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.trackColors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final halfHeight = constraints.maxHeight / 2;
          final trackWidth = constraints.maxWidth - constraints.maxHeight;
          final normalizedValue = value / maxValue;
          final indicatorPosition = halfHeight + trackWidth * normalizedValue;
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
                child: CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ColorChannelTrackPainter(trackColors),
                ),
              ),
              Positioned(
                left: indicatorPosition - constraints.maxHeight / 2,
                child: CustomPaint(
                  size: Size(constraints.maxHeight, constraints.maxHeight),
                  painter: ColorChannelIndicatorPainter(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ColorChannelTrackPainter extends CustomPainter {
  final List<Color> colors;

  const ColorChannelTrackPainter(this.colors);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..shader = LinearGradient(colors: colors).createShader(rect),
    );
  }
}

class ColorChannelIndicatorPainter extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset.zero,
      size.height / 2,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}
