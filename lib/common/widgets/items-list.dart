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
}

@immutable
class ItemsListViewModel<ItemType> {
  final bool isLoading;
  final List<ItemType> items;
  final bool hasMoreItems;

  const ItemsListViewModel({
    required this.isLoading,
    required this.items,
    required this.hasMoreItems,
  });

  factory ItemsListViewModel.initialState() {
    return const ItemsListViewModel(
      isLoading: false,
      items: [],
      hasMoreItems: true,
    );
  }
}

class ItemsListView<ItemType> extends StatelessWidget {
  final ItemsListViewModel<ItemType> viewModel;
  final Widget Function(ItemType item) itemTileBuilder;
  final void Function() onLoadMorePressed;

  const ItemsListView({
    super.key,
    required this.viewModel,
    required this.itemTileBuilder,
    required this.onLoadMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.items.length + (viewModel.hasMoreItems ? 1 : 0),
      itemBuilder: (context, index) {
        if (viewModel.hasMoreItems && index == viewModel.items.length) {
          if (viewModel.isLoading) {
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
          final pattern = viewModel.items[index];
          return itemTileBuilder(pattern);
        }
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }
}
