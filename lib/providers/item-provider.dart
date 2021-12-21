import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemProvider<ItemType> extends StateNotifier<ItemType?> {
  final Future<ItemType?> Function(ClClient client) callback;

  final _client = ClClient();

  ItemProvider(this.callback) : super(null);

  Future<void> load() async {
    state = await callback(_client);
  }
}
