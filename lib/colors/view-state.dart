import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';

@immutable
class ColorsViewState {
  final ColorFiltersViewState filters;
  final ItemsListViewState<ColorTileViewState> itemsList;

  const ColorsViewState({
    required this.filters,
    required this.itemsList,
  });

  factory ColorsViewState.initialState() {
    return ColorsViewState(
      filters: ColorFiltersViewState.initialState(),
      itemsList: ItemsListViewState.initialState(),
    );
  }
}
