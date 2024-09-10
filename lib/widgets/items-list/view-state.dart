import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
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
