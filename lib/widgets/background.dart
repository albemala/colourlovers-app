import 'dart:math';

import 'package:aurora/aurora.dart';
import 'package:flutter/material.dart';

// TODO remove?

class BackgroundView extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final List<Offset> positionRatios;
  final List<double> sizeRatios;

  BackgroundView({
    super.key,
    required this.child,
    required this.colors,
  })  : positionRatios = List.generate(colors.length, (index) => nextOffset()),
        sizeRatios = List.generate(colors.length, (index) => nextSize());

  @override
  Widget build(BuildContext context) {
    return child;
    // print('BackgroundView.build');
    // print('colors: $colors');
    // print('positionRatios: $positionRatios');
    // print('sizeRatios: $sizeRatios');
    return Stack(
      children: [
        ...List.generate(
          colors.length,
          (index) => Positioned(
            top: MediaQuery.of(context).size.height * positionRatios[index].dy,
            left: MediaQuery.of(context).size.width * positionRatios[index].dx,
            child: Aurora(
              size: MediaQuery.of(context).size.width * sizeRatios[index],
              colors: [
                colors[index].withOpacity(1),
                colors[index].withOpacity(1),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

Offset nextOffset() {
  final random = Random();
  // between -0.5 and 1.5
  return Offset(
    0,
    0,
    // random.nextDouble() * 2 - 0.5,
    // random.nextDouble() * 2 - 0.5,
  );
}

double nextSize() {
  final random = Random();
  return random.nextDouble();
}
