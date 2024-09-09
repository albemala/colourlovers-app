import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ColorsViewState extends Equatable {
  final ColorFiltersViewState filters;
  final ItemsListViewState<ColorTileViewState> itemsList;

  const ColorsViewState({
    required this.filters,
    required this.itemsList,
  });

  @override
  List<Object?> get props => [filters, itemsList];

  ColorsViewState copyWith({
    ColorFiltersViewState? filters,
    ItemsListViewState<ColorTileViewState>? itemsList,
  }) {
    return ColorsViewState(
      filters: filters ?? this.filters,
      itemsList: itemsList ?? this.itemsList,
    );
  }
}

const defaultColorsViewState = ColorsViewState(
  filters: defaultColorFiltersViewState,
  itemsList: defaultColorsListViewState,
);
