import 'package:flutter/material.dart';

class ColorChannelValueView extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> trackColors;

  const ColorChannelValueView({
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
      child: Stack(
        children: [
          ColorChannelTrackView(
            trackColors: trackColors,
          ),
          ColorChannelIndicatorView(
            value: value,
            maxValue: maxValue,
          ),
        ],
      ),
    );
  }
}

class ColorChannelTrackView extends StatelessWidget {
  final List<Color> trackColors;

  const ColorChannelTrackView({
    super.key,
    required this.trackColors,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
            child: CustomPaint(
              painter: ColorChannelTrackPainter(trackColors),
            ),
          ),
        );
      },
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

class ColorChannelIndicatorView extends StatelessWidget {
  final double value;
  final double maxValue;

  const ColorChannelIndicatorView({
    super.key,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform.translate(
          offset: Offset(
            constraints.maxHeight / 2 +
                (constraints.maxWidth - constraints.maxHeight) *
                    value /
                    maxValue,
            constraints.maxHeight / 2,
          ),
          child: SizedBox(
            width: constraints.maxHeight,
            height: constraints.maxHeight,
            child: CustomPaint(
              painter: ColorChannelIndicatorPainter(),
            ),
          ),
        );
      },
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
