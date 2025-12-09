import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
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
  final String hex;
  final String paletteName;
  final String userName;
  final IList<BackgroundBlob> backgroundBlobs;

  const PaletteFiltersViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.colorFilter,
    required this.hueRanges,
    required this.hex,
    required this.paletteName,
    required this.userName,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [
    showCriteria,
    sortBy,
    sortOrder,
    colorFilter,
    hueRanges,
    hex,
    paletteName,
    userName,
    backgroundBlobs,
  ];

  PaletteFiltersViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    ColorFilter? colorFilter,
    IList<ColourloversRequestHueRange>? hueRanges,
    String? hex,
    String? paletteName,
    String? userName,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return PaletteFiltersViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      colorFilter: colorFilter ?? this.colorFilter,
      hueRanges: hueRanges ?? this.hueRanges,
      hex: hex ?? this.hex,
      paletteName: paletteName ?? this.paletteName,
      userName: userName ?? this.userName,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }

  factory PaletteFiltersViewState.initial() {
    return const PaletteFiltersViewState(
      showCriteria: ContentShowCriteria.newest,
      sortBy: ColourloversRequestOrderBy.dateCreated,
      sortOrder: ColourloversRequestSortBy.DESC,
      colorFilter: ColorFilter.none,
      hueRanges: IList.empty(),
      hex: '',
      paletteName: '',
      userName: '',
      backgroundBlobs: IList.empty(),
    );
  }
}
