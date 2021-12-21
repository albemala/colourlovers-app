import 'package:colourlovers_api/colourlovers_api.dart';

class ItemService<ItemType, IdType> {
  final Future<ItemType?> Function(ClClient client, IdType id) callback;

  final _client = ClClient();

  ItemService(this.callback);

  Future<ItemType?> load(IdType id) async {
    return await callback(
      _client,
      id,
    );
  }
}
