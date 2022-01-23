import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/utils/user-items.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _numResults = 3;

List<ClColor> loadUserColors(String userName) {
  return useFuture(
        useMemoized(() async {
          final client = ClClient();
          return getUserColors(client, _numResults, 0, userName);
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPalette> loadUserPalettes(String userName) {
  return useFuture(
        useMemoized(() async {
          final client = ClClient();
          return getUserPalettes(client, _numResults, 0, userName);
        }),
        initialData: null,
      ).data ??
      [];
}

List<ClPattern> loadUserPatterns(String userName) {
  return useFuture(
        useMemoized(() async {
          final client = ClClient();
          return getUserPatterns(client, _numResults, 0, userName);
        }),
        initialData: null,
      ).data ??
      [];
}
