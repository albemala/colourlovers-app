import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class RelatedPalettesViewState extends Equatable {
  final ItemListViewState<PaletteTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const RelatedPalettesViewState({
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [itemsList, backgroundBlobs];

  RelatedPalettesViewState copyWith({
    ItemListViewState<PaletteTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return RelatedPalettesViewState(
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultRelatedPalettesViewState = RelatedPalettesViewState(
  itemsList: defaultPalettesListViewState,
  backgroundBlobs: IList.empty(),
);
