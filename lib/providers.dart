import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/services/item-service.dart';
import 'package:colourlovers_app/services/items-service.dart';
import 'package:colourlovers_app/services/routing-service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routingService = StateNotifierProvider<RoutingService, MainRoute>((ref) {
  return RoutingService();
});

final colorsService = StateNotifierProvider<ItemsService<ClColor>, ItemsState<ClColor>>((ref) {
  return ItemsService(
    (client, numResults, resultOffset) async {
      return await client.getColors(
        numResults: numResults,
        resultOffset: resultOffset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ClRequestSortBy.DESC,
      );
    },
  );
});
final palettesService = StateNotifierProvider<ItemsService<ClPalette>, ItemsState<ClPalette>>((ref) {
  return ItemsService(
    (client, numResults, resultOffset) async {
      return await client.getPalettes(
        numResults: numResults,
        resultOffset: resultOffset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ClRequestSortBy.DESC,
        showPaletteWidths: true,
      );
    },
  );
});
final patternsService = StateNotifierProvider<ItemsService<ClPattern>, ItemsState<ClPattern>>((ref) {
  return ItemsService(
    (client, numResults, resultOffset) async {
      return await client.getPatterns(
        numResults: numResults,
        resultOffset: resultOffset,
        sortBy: ClRequestSortBy.DESC,
      );
    },
  );
});
final usersService = StateNotifierProvider<ItemsService<ClLover>, ItemsState<ClLover>>((ref) {
  return ItemsService(
    (client, numResults, resultOffset) async {
      return await client.getLovers(
        numResults: numResults,
        resultOffset: resultOffset,
        sortBy: ClRequestSortBy.DESC,
      );
    },
  );
});

final colorService = Provider<ItemService<ClColor, String>>((ref) {
  return ItemService(
    (client, id) async {
      return await client.getColor(hex: id);
    },
  );
});
final paletteService = Provider<ItemService<ClPalette, int>>((ref) {
  return ItemService(
    (client, id) async {
      return await client.getPalette(id: id);
    },
  );
});
final patternService = Provider<ItemService<ClPattern, int>>((ref) {
  return ItemService(
    (client, id) async {
      return await client.getPattern(id: id);
    },
  );
});
final userService = Provider<ItemService<ClLover, String>>((ref) {
  return ItemService(
    (client, id) async {
      return await client.getLover(userName: id);
    },
  );
});
