import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class PaletteFiltersViewState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final ColorFilter colorFilter;
  final IList<ColourloversRequestHueRange> hueRanges;

  const PaletteFiltersViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.colorFilter,
    required this.hueRanges,
  });

  @override
  List<Object?> get props => [
        showCriteria,
        sortBy,
        sortOrder,
        colorFilter,
        hueRanges,
      ];

  PaletteFiltersViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    ColorFilter? colorFilter,
    IList<ColourloversRequestHueRange>? hueRanges,
  }) {
    return PaletteFiltersViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      colorFilter: colorFilter ?? this.colorFilter,
      hueRanges: hueRanges ?? this.hueRanges,
    );
  }
}

const defaultPaletteFiltersViewState = PaletteFiltersViewState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  colorFilter: ColorFilter.none,
  hueRanges: IList.empty(),
);
