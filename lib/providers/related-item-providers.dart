import 'dart:math';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _numResults = 3;

List<ClColor> getRelatedColors(Hsv? hsv) {
  return useFuture(
        useMemoized(() async {
          final hue = hsv?.hue ?? 0;
          final value = hsv?.value ?? 0;
          const delta = 20;
          return ClClient().getTopColors(
            hueMin: max(0, hue - delta),
            hueMax: min(359, hue + delta),
            brightnessMin: max(0, value - delta),
            brightnessMax: min(99, value + delta),
            numResults: _numResults,
          );
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPalette> getRelatedPalettes(List<String>? hex) {
  return useFuture(
        useMemoized(() async {
          return ClClient().getTopPalettes(
            hex: hex ?? [],
            hexLogic: ClRequestHexLogic.OR,
            numResults: _numResults,
          );
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPattern> getRelatedPatterns(List<String>? hex) {
  return useFuture(
        useMemoized(() async {
          return ClClient().getTopPatterns(
            hex: hex ?? [],
            hexLogic: ClRequestHexLogic.OR,
            numResults: _numResults,
          );
        }),
        initialData: null,
      ).data ??
      [];
}
