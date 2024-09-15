import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class PatternsViewState extends Equatable {
  // filters
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final ColorFilter colorFilter;
  final IList<ColourloversRequestHueRange> hueRanges;
  final String hex;
  final String patternName;
  final String userName;

  // items
  final ItemsListViewState<PatternTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const PatternsViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.colorFilter,
    required this.hueRanges,
    required this.hex,
    required this.patternName,
    required this.userName,
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object?> get props => [
        showCriteria,
        sortBy,
        sortOrder,
        colorFilter,
        hueRanges,
        hex,
        patternName,
        userName,
        itemsList,
        backgroundBlobs,
      ];

  PatternsViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    ColorFilter? colorFilter,
    IList<ColourloversRequestHueRange>? hueRanges,
    String? hex,
    String? patternName,
    String? userName,
    ItemsListViewState<PatternTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return PatternsViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      colorFilter: colorFilter ?? this.colorFilter,
      hueRanges: hueRanges ?? this.hueRanges,
      hex: hex ?? this.hex,
      patternName: patternName ?? this.patternName,
      userName: userName ?? this.userName,
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultPatternsViewState = PatternsViewState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  colorFilter: ColorFilter.none,
  hueRanges: IList.empty(),
  hex: '',
  patternName: '',
  userName: '',
  itemsList: defaultPatternsListViewState,
  backgroundBlobs: IList.empty(),
);
