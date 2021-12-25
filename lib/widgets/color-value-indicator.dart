import 'package:flutter/material.dart';

const double _widgetHeight = 16;
const double _trackHeight = 8;
const double _dotRadius = 6;
const double _dotBorderWidth = 2;

class ColorValueIndicatorWidget extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> trackColors;

  const ColorValueIndicatorWidget({
    Key? key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.trackColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final widgetWidth = box.maxWidth;
        return SizedBox(
          width: widgetWidth,
          height: _widgetHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              _TrackWidget(
                width: widgetWidth,
                trackColors: trackColors,
              ),
              _DotWidget(
                value: value,
                maxValue: maxValue,
                width: widgetWidth,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackWidget extends StatelessWidget {
  final double width;
  final List<Color> trackColors;

  const _TrackWidget({
    Key? key,
    required this.width,
    required this.trackColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: width,
      height: _trackHeight,
      left: 0,
      top: _widgetHeight / 2 - _trackHeight / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_trackHeight / 2),
        child: CustomPaint(
          painter: _TrackPainter(trackColors),
        ),
      ),
    );
  }
}

class _DotWidget extends StatelessWidget {
  final double value;
  final double maxValue;
  final double width;

  const _DotWidget({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: _dotRadius * 2,
      height: _dotRadius * 2,
      left: _dotRadius + (width - _dotRadius * 2) * (value / maxValue),
      top: _widgetHeight / 2,
      child: CustomPaint(
        painter: _DotPainter(),
      ),
    );
  }
}

class _TrackPainter extends CustomPainter {
  final List<Color> colors;

  const _TrackPainter(this.colors);

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

class _DotPainter extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset.zero,
      _dotRadius - _dotBorderWidth / 2,
      Paint()
        ..color = Colors.white
        ..strokeWidth = _dotBorderWidth
        ..style = PaintingStyle.stroke,
    );
  }
}
