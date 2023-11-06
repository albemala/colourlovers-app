import 'dart:math';

import 'package:colourlovers_api/colourlovers_api.dart';

Future<List<ColourloversColor>> fetchRelatedColors(
  ColourloversApiClient client,
  int numResults,
  int resultOffset,
  Hsv hsv,
) async {
  final hue = hsv.hue ?? 0;
  final value = hsv.value ?? 0;
  const delta = 20;
  final colors = await client.getTopColors(
    hueMin: max(0, hue - delta),
    hueMax: min(359, hue + delta),
    brightnessMin: max(0, value - delta),
    brightnessMax: min(99, value + delta),
    numResults: numResults,
    resultOffset: resultOffset,
    // orderBy: ClRequestOrderBy.numVotes,
    // sortBy: ClRequestSortBy.DESC,
  );
  return colors ?? [];
}

Future<List<ColourloversPalette>> fetchRelatedPalettes(
  ColourloversApiClient client,
  int numResults,
  int resultOffset,
  List<String> hex,
) async {
  if (hex.isEmpty) return [];
  final palettes = await client.getTopPalettes(
    hex: hex,
    hexLogic: ColourloversRequestHexLogic.OR,
    numResults: numResults,
    resultOffset: resultOffset,
    // orderBy: ClRequestOrderBy.numVotes,
    // sortBy: ClRequestSortBy.DESC,
  );
  return palettes ?? [];
}

Future<List<ColourloversPattern>> fetchRelatedPatterns(
  ColourloversApiClient client,
  int numResults,
  int resultOffset,
  List<String> hex,
) async {
  if (hex.isEmpty) return [];
  final patterns = await client.getTopPatterns(
    hex: hex,
    hexLogic: ColourloversRequestHexLogic.OR,
    numResults: numResults,
    resultOffset: resultOffset,
    // orderBy: ClRequestOrderBy.numVotes,
    // sortBy: ClRequestSortBy.DESC,
  );
  return patterns ?? [];
}

const _numResults = 3;

Future<List<ColourloversColor>> fetchRelatedColorsPreview(
  ColourloversApiClient client,
  Hsv hsv,
) async {
  return fetchRelatedColors(client, _numResults, 0, hsv);
}

Future<List<ColourloversPalette>> fetchRelatedPalettesPreview(
  ColourloversApiClient client,
  List<String> hex,
) async {
  return fetchRelatedPalettes(client, _numResults, 0, hex);
}

Future<List<ColourloversPattern>> fetchRelatedPatternsPreview(
  ColourloversApiClient client,
  List<String> hex,
) async {
  return fetchRelatedPatterns(client, _numResults, 0, hex);
}
