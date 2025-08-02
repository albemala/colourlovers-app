import 'package:flutter/material.dart';

class SkewedContainerView extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double? elevation;
  final Widget child;

  const SkewedContainerView({
    super.key,
    required this.padding,
    this.color,
    this.elevation,
    required this.child,
  });

  const SkewedContainerView.large({
    super.key,
    this.color,
    this.elevation,
    required this.child,
  }) : padding = const EdgeInsets.fromLTRB(16, 8, 21, 8);

  const SkewedContainerView.small({
    super.key,
    this.color,
    this.elevation,
    required this.child,
  }) : padding = const EdgeInsets.fromLTRB(8, 4, 12, 4);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(3),
      child: Material(
        type: MaterialType.card,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(2),
        elevation: elevation ?? 4,
        child: Transform(
          transform: Matrix4.skewX(-3),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
