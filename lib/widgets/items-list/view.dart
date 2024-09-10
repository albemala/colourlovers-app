import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:flutter/material.dart';

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
