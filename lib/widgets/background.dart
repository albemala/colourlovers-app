import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

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
  final List<_Circle> circles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCircles();
  }

  void _initCircles() {
    final size = MediaQuery.of(context).size;
    final random = Random();
    for (var i = 3; i < 3 + random.nextInt(10); i += 1) {
      final color = widget.colors[random.nextInt(widget.colors.length)];
      final Paint paint = Paint()..color = color;
      final double radius = size.width / 4 + random.nextDouble() * size.width / 2;
      final Offset offset = Offset(
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
              colors: widget.colors,
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
    for (var circle in circles) {
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
