import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RelatedItemsProvider<ItemType> extends StateNotifier<List<ItemType>> {
  final Future<List<ItemType>?> Function(ClClient client, int numResults) callback;

  final _client = ClClient();

  RelatedItemsProvider(this.callback) : super([]);

  Future<void> load() async {
    const numResults = 3;
    state = await callback(
          _client,
          numResults,
        ) ??
        [];
  }
}
