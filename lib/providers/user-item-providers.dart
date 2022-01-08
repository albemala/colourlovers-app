import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _numResults = 3;

List<ClColor> getUserColors(String userName) {
  return useFuture(
        useMemoized(() async {
          return await ClClient().getTopColors(
            lover: userName,
            numResults: _numResults,
          );
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPalette> getUserPalettes(String userName) {
  return useFuture(
        useMemoized(() async {
          return await ClClient().getTopPalettes(
            lover: userName,
            numResults: _numResults,
          );
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPattern> getUserPatterns(String userName) {
  return useFuture(
        useMemoized(() async {
          return await ClClient().getTopPatterns(
            lover: userName,
            numResults: _numResults,
          );
        }),
        initialData: null,
      ).data ??
      [];
}
