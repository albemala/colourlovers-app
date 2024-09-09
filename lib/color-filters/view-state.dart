import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/item-filters/defines.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

@immutable
class ColorFiltersViewState extends Equatable {
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

  @override
  List<Object?> get props => [
    filter,
    sortBy,
    order,
    hueMin,
    hueMax,
    brightnessMin,
    brightnessMax,
    colorName,
    userName,
  ];

  ColorFiltersViewState copyWith({
    ItemsFilter? filter,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? order,
    int? hueMin,
    int? hueMax,
    int? brightnessMin,
    int? brightnessMax,
    String? colorName,
    String? userName,
  }) {
    return ColorFiltersViewState(
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
      hueMin: hueMin ?? this.hueMin,
      hueMax: hueMax ?? this.hueMax,
      brightnessMin: brightnessMin ?? this.brightnessMin,
      brightnessMax: brightnessMax ?? this.brightnessMax,
      colorName: colorName ?? this.colorName,
      userName: userName ?? this.userName,
    );
  }
}

const defaultColorFiltersViewState = ColorFiltersViewState(
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
