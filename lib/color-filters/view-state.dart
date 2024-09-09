import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/item-filters/defines.dart';
import 'package:flutter/material.dart';

@immutable
class ColorFiltersViewState {
  final ItemsFilter filter;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy order;
  final int hueMin;
  final int hueMax;
  final int brightnessMin;
  final int brightnessMax;
  final String colorName;
  final String userName;

  const ColorFiltersViewState({
    required this.filter,
    required this.sortBy,
    required this.order,
    required this.hueMin,
    required this.hueMax,
    required this.brightnessMin,
    required this.brightnessMax,
    required this.colorName,
    required this.userName,
  });

  factory ColorFiltersViewState.initialState() {
    return const ColorFiltersViewState(
      filter: ItemsFilter.newest,
      sortBy: ColourloversRequestOrderBy.numVotes,
      order: ColourloversRequestSortBy.DESC,
      hueMin: 0,
      hueMax: 359,
      brightnessMin: 0,
      brightnessMax: 99,
      colorName: '',
      userName: '',
    );
  }
}
