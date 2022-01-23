import 'package:colourlovers_api/colourlovers_api.dart';

Future<List<ClColor>?> getUserColors(
  ClClient client,
  int numResults,
  int resultOffset,
  String userName,
) {
  return client.getTopColors(
    lover: userName,
    numResults: numResults,
    resultOffset: resultOffset,
  );
}

Future<List<ClPalette>?> getUserPalettes(
  ClClient client,
  int numResults,
  int resultOffset,
  String userName,
) {
  return client.getTopPalettes(
    lover: userName,
    numResults: numResults,
    resultOffset: resultOffset,
  );
}

Future<List<ClPattern>?> getUserPatterns(
  ClClient client,
  int numResults,
  int resultOffset,
  String userName,
) {
  return client.getTopPatterns(
    lover: userName,
    numResults: numResults,
    resultOffset: resultOffset,
  );
}
