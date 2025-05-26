import 'package:flutter/foundation.dart';

class ItemsPagination<ItemType> extends ChangeNotifier {
  final Future<List<ItemType>?> Function(int numResults, int offset) loadItems;

  bool isLoading = false;
  List<ItemType> items = [];
  int page = 0;
  bool hasMoreItems = true;

  ItemsPagination(this.loadItems);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    const numResults = 20;
    final newItems = await loadItems(numResults, page * numResults) ?? [];

    isLoading = false;
    items = [...items, ...newItems];
    hasMoreItems = newItems.length == numResults;
    notifyListeners();
  }

  Future<void> loadMore() async {
    page++;
    await load();
  }

  void reset() {
    isLoading = false;
    items = [];
    page = 0;
    hasMoreItems = true;
    notifyListeners();
  }
}
