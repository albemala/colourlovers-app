import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

final defaultBackgroundColors = [
  const Color(0xFFF43F5E),
  const Color(0xFFA855F7),
];

class BackgroundWidget extends StatefulWidget {
  final List<Color> colors;
  final Widget child;

  const BackgroundWidget({
    Key? key,
    required this.colors,
    required this.child,
  }) : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  final List<Color> colors = [];
  final List<_Circle> circles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initColors();
    _initCircles();
  }

  void _initColors() {
    if (colors.isNotEmpty) return;

    colors.addAll(widget.colors.map((e) => e.withOpacity(0.3)));
    colors.add(Theme.of(context).backgroundColor);
  }

  void _initCircles() {
    if (circles.isNotEmpty) return;

    final size = MediaQuery.of(context).size;
    final random = Random();
    const min = 3;
    final max = min + random.nextInt(10);
    for (var i = min; i < max; i += 1) {
      final color = colors[random.nextInt(colors.length)];
      final paint = Paint()..color = color;
      final radius = size.width / 4 + random.nextDouble() * size.width / 2;
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      circles.add(
        _Circle(
          paint: paint,
          radius: radius,
          offset: offset,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: _BackgroundPainter(
              colors: colors,
              circles: circles,
            ),
          ),
        ),
        SizedBox.expand(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 80,
              sigmaY: 80,
            ),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final List<Color> colors;
  final List<_Circle> circles;

  const _BackgroundPainter({
    required this.colors,
    required this.circles,
  });

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    for (final circle in circles) {
      canvas.drawCircle(circle.offset, circle.radius, circle.paint);
    }
  }
}

class _Circle {
  final Paint paint;
  final double radius;
  final Offset offset;

  _Circle({
    required this.paint,
    required this.radius,
    required this.offset,
  });
}
