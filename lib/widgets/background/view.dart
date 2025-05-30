import 'package:aurora/aurora.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:flutter/material.dart';

class BackgroundView extends StatelessWidget {
  final Widget child;
  final List<BackgroundBlob> blobs;

  const BackgroundView({super.key, required this.child, required this.blobs});

  @override
  Widget build(BuildContext context) {
    if (blobs.isEmpty) return child;
    return Stack(
      fit: StackFit.expand,
      children: [
        ...blobs.map(
          (blob) => Positioned(
            top: MediaQuery.of(context).size.height * blob.positionRatio.dy,
            left: MediaQuery.of(context).size.width * blob.positionRatio.dx,
            child: Aurora(
              size: MediaQuery.of(context).size.width * blob.sizeRatio,
              colors:
                  blob.colors.map((color) {
                    final opacity =
                        Theme.of(context).brightness == Brightness.dark
                            ? 1.0
                            : 0.5;
                    return color.withValues(alpha: opacity);
                  }).toList(),
              blur: blob.blur,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
