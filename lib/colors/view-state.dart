import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ColorsViewState extends Equatable {
  // filters
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final int hueMin;
  final int hueMax;
  final int brightnessMin;
  final int brightnessMax;
  final String colorName;
  final String userName;

  // items
  final ItemsListViewState<ColorTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const ColorsViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.hueMin,
    required this.hueMax,
    required this.brightnessMin,
    required this.brightnessMax,
    required this.colorName,
    required this.userName,
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object?> get props => [
        showCriteria,
        sortBy,
        sortOrder,
        hueMin,
        hueMax,
        brightnessMin,
        brightnessMax,
        colorName,
        userName,
        itemsList,
        backgroundBlobs,
      ];

  ColorsViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    int? hueMin,
    int? hueMax,
    int? brightnessMin,
    int? brightnessMax,
    String? colorName,
    String? userName,
    ItemsListViewState<ColorTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return ColorsViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      hueMin: hueMin ?? this.hueMin,
      hueMax: hueMax ?? this.hueMax,
      brightnessMin: brightnessMin ?? this.brightnessMin,
      brightnessMax: brightnessMax ?? this.brightnessMax,
      colorName: colorName ?? this.colorName,
      userName: userName ?? this.userName,
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultColorsViewState = ColorsViewState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  hueMin: 0,
  hueMax: 359,
  brightnessMin: 0,
  brightnessMax: 99,
  colorName: '',
  userName: '',
  itemsList: defaultColorsListViewState,
  backgroundBlobs: IList.empty(),
);
