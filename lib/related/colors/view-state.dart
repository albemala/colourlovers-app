import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class RelatedColorsViewState extends Equatable {
  final ItemListViewState<ColorTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const RelatedColorsViewState({
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [itemsList, backgroundBlobs];

  RelatedColorsViewState copyWith({
    ItemListViewState<ColorTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return RelatedColorsViewState(
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultRelatedColorsViewState = RelatedColorsViewState(
  itemsList: defaultColorsListViewState,
  backgroundBlobs: IList.empty(),
);
