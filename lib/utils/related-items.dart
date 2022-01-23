import 'dart:math';

import 'package:colourlovers_api/colourlovers_api.dart';

Future<List<ClColor>?> getRelatedColors(
  ClClient client,
  int numResults,
  int resultOffset,
  Hsv? hsv,
) {
  final hue = hsv?.hue ?? 0;
  final value = hsv?.value ?? 0;
  const delta = 20;
  return client.getTopColors(
    hueMin: max(0, hue - delta),
    hueMax: min(359, hue + delta),
    brightnessMin: max(0, value - delta),
    brightnessMax: min(99, value + delta),
    numResults: numResults,
    resultOffset: resultOffset,
    // orderBy: ClRequestOrderBy.numVotes,
    // sortBy: ClRequestSortBy.DESC,
  );
}

Future<List<ClPalette>?> getRelatedPalettes(
  ClClient client,
  int numResults,
  int resultOffset,
  List<String>? hex,
) {
  return client.getTopPalettes(
    hex: hex ?? [],
    hexLogic: ClRequestHexLogic.OR,
    numResults: numResults,
    resultOffset: resultOffset,
    // orderBy: ClRequestOrderBy.numVotes,
    // sortBy: ClRequestSortBy.DESC,
  );
}

Future<List<ClPattern>?> getRelatedPatterns(
  ClClient client,
  int numResults,
  int resultOffset,
  List<String>? hex,
) {
  return client.getTopPatterns(
    hex: hex ?? [],
    hexLogic: ClRequestHexLogic.OR,
    numResults: numResults,
    resultOffset: resultOffset,
    // orderBy: ClRequestOrderBy.numVotes,
    // sortBy: ClRequestSortBy.DESC,
  );
}
