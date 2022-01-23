import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/utils/related-items.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _numResults = 3;

List<ClColor> loadRelatedColors(Hsv? hsv) {
  return useFuture(
        useMemoized(() async {
          return getRelatedColors(ClClient(), _numResults, 0, hsv);
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPalette> loadRelatedPalettes(List<String>? hex) {
  return useFuture(
        useMemoized(() async {
          return getRelatedPalettes(ClClient(), _numResults, 0, hex);
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPattern> loadRelatedPatterns(List<String>? hex) {
  return useFuture(
        useMemoized(() async {
          return getRelatedPatterns(ClClient(), _numResults, 0, hex);
        }),
        initialData: null,
      ).data ??
      [];
}
