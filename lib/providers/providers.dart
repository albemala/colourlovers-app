import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/items.dart';
import 'package:colourlovers_app/providers/routing.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routingProvider = StateNotifierProvider<RoutingProvider, MainRoute>((ref) {
  return RoutingProvider();
});

final colorsProvider = StateNotifierProvider<ItemsProvider<ClColor>, ItemsState<ClColor>>((ref) {
  return ItemsProvider(
    (client, numResults, resultOffset) async {
      return client.getColors(
        numResults: numResults,
        resultOffset: resultOffset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ClRequestSortBy.DESC,
      );
    },
  );
});
final palettesProvider = StateNotifierProvider<ItemsProvider<ClPalette>, ItemsState<ClPalette>>((ref) {
  return ItemsProvider(
    (client, numResults, resultOffset) async {
      return client.getPalettes(
        numResults: numResults,
        resultOffset: resultOffset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ClRequestSortBy.DESC,
        showPaletteWidths: true,
      );
    },
  );
});
final patternsProvider = StateNotifierProvider<ItemsProvider<ClPattern>, ItemsState<ClPattern>>((ref) {
  return ItemsProvider(
    (client, numResults, resultOffset) async {
      return client.getPatterns(
        numResults: numResults,
        resultOffset: resultOffset,
        sortBy: ClRequestSortBy.DESC,
      );
    },
  );
});
final usersProvider = StateNotifierProvider<ItemsProvider<ClLover>, ItemsState<ClLover>>((ref) {
  return ItemsProvider(
    (client, numResults, resultOffset) async {
      return client.getLovers(
        numResults: numResults,
        resultOffset: resultOffset,
        sortBy: ClRequestSortBy.DESC,
      );
    },
  );
});
