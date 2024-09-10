import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ItemsListViewState<ItemType> extends Equatable {
  final bool isLoading;
  final IList<ItemType> items;
  final bool hasMoreItems;

  const ItemsListViewState({
    required this.isLoading,
    required this.items,
    required this.hasMoreItems,
  });

  @override
  List<Object?> get props => [isLoading, items, hasMoreItems];

  ItemsListViewState<ItemType> copyWith({
    bool? isLoading,
    IList<ItemType>? items,
    bool? hasMoreItems,
  }) {
    return ItemsListViewState<ItemType>(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
    );
  }
}

const defaultColorsListViewState = ItemsListViewState<ColorTileViewState>(
  isLoading: false,
  items: IList.empty(),
  hasMoreItems: true,
);

const defaultPalettesListViewState = ItemsListViewState<PaletteTileViewState>(
  isLoading: false,
  items: IList.empty(),
  hasMoreItems: true,
);

const defaultPatternsListViewState = ItemsListViewState<PatternTileViewState>(
  isLoading: false,
  items: IList.empty(),
  hasMoreItems: true,
);

const defaultUsersListViewState = ItemsListViewState<UserTileViewState>(
  isLoading: false,
  items: IList.empty(),
  hasMoreItems: true,
);

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
