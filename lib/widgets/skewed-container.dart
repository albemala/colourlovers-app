import 'package:flutter/material.dart';

class SkewedContainerWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Color color;
  final double elevation;
  final Widget child;

  const SkewedContainerWidget({
    Key? key,
    required this.padding,
    required this.color,
    this.elevation = 0,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(3),
      child: Material(
        type: MaterialType.card,
        color: color,
        borderRadius: BorderRadius.circular(2),
        elevation: elevation,
        child: Transform(
          transform: Matrix4.skewX(-3),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
