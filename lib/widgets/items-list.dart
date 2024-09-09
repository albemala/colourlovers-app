import 'package:flutter/material.dart';

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
    final newItems = await loadItems(
          numResults,
          page * numResults,
        ) ??
        [];

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

@immutable
class ItemsListViewState<ItemType> {
  final bool isLoading;
  final List<ItemType> items;
  final bool hasMoreItems;

  const ItemsListViewState({
    required this.isLoading,
    required this.items,
    required this.hasMoreItems,
  });

  factory ItemsListViewState.initialState() {
    return const ItemsListViewState(
      isLoading: false,
      items: [],
      hasMoreItems: true,
    );
  }
}

class ItemsListView<ItemType> extends StatelessWidget {
  final ItemsListViewState<ItemType> state;
  final Widget Function(ItemType item) itemTileBuilder;
  final void Function() onLoadMorePressed;

  const ItemsListView({
    super.key,
    required this.state,
    required this.itemTileBuilder,
    required this.onLoadMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.items.length + (state.hasMoreItems ? 1 : 0),
      itemBuilder: (context, index) {
        if (state.hasMoreItems && index == state.items.length) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return OutlinedButton(
              onPressed: onLoadMorePressed,
              child: const Text('Load more'),
            );
          }
        } else {
          final pattern = state.items[index];
          return itemTileBuilder(pattern);
        }
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }
}
