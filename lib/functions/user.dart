import 'package:colourlovers_api/colourlovers_api.dart';

Future<ColourloversLover?> fetchUser(
  ColourloversApiClient client,
  String userName,
) async {
  if (userName.isEmpty) return null;
  return client.getLover(userName: userName);
}

Future<List<ColourloversColor>> fetchUserColors(
  ColourloversApiClient client,
  int numResults,
  int resultOffset,
  String userName,
) async {
  if (userName.isEmpty) return [];
  final colors = await client.getTopColors(
    lover: userName,
    numResults: numResults,
    resultOffset: resultOffset,
  );
  return colors ?? [];
}

Future<List<ColourloversPalette>> fetchUserPalettes(
  ColourloversApiClient client,
  int numResults,
  int resultOffset,
  String userName,
) async {
  if (userName.isEmpty) return [];
  final palettes = await client.getTopPalettes(
    lover: userName,
    numResults: numResults,
    resultOffset: resultOffset,
    showPaletteWidths: true,
  );
  return palettes ?? [];
}

Future<List<ColourloversPattern>> fetchUserPatterns(
  ColourloversApiClient client,
  int numResults,
  int resultOffset,
  String userName,
) async {
  if (userName.isEmpty) return [];
  final patterns = await client.getTopPatterns(
    lover: userName,
    numResults: numResults,
    resultOffset: resultOffset,
  );
  return patterns ?? [];
}

const _numResults = 3;

Future<List<ColourloversColor>> fetchUserColorsPreview(
  ColourloversApiClient client,
  String userName,
) async {
  return fetchUserColors(client, _numResults, 0, userName);
}

Future<List<ColourloversPalette>> fetchUserPalettesPreview(
  ColourloversApiClient client,
  String userName,
) async {
  return fetchUserPalettes(client, _numResults, 0, userName);
}

Future<List<ColourloversPattern>> fetchUserPatternsPreview(
  ColourloversApiClient client,
  String userName,
) async {
  return fetchUserPatterns(client, _numResults, 0, userName);
}
