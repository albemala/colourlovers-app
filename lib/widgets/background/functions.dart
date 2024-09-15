import 'dart:math';
import 'dart:ui';

import 'package:colourlovers_app/widgets/background/defines.dart';

List<Color> getRandomPalette() {
  final random = Random();
  final selectedPalette = topPalettes[random.nextInt(topPalettes.length)];
  return selectedPalette.map(_hexToColor).toList();
}

Color _hexToColor(String hexString) {
  return Color(int.parse('FF$hexString', radix: 16));
}

List<BackgroundBlob> generateBackgroundBlobs(List<Color> colors) {
  final random = Random();
  final blobCount = random.nextInt(3) + 3; // Random between 3 and 5
  return List.generate(
    blobCount,
    (_) {
      final blobColors = List.generate(
        2,
        (_) => colors[random.nextInt(colors.length)],
      );
      return BackgroundBlob(
        positionRatio: _randomOffset(),
        sizeRatio: _randomSize(),
        colors: blobColors,
        blur: _randomBlur(),
      );
    },
  );
}

Offset _randomOffset() {
  final random = Random();
  // between -0.2 and 1.2
  return Offset(
    random.nextDouble() * 1.4 - 0.2,
    random.nextDouble() * 1.4 - 0.2,
  );
}

double _randomSize() {
  final random = Random();
  return random.nextDouble();
}

double _randomBlur() {
  final random = Random();
  // between 100 and 300
  return random.nextDouble() * 200 + 100;
}
