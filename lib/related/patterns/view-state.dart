import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class RelatedPatternsViewState extends Equatable {
  final ItemListViewState<PatternTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const RelatedPatternsViewState({
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [itemsList, backgroundBlobs];

  RelatedPatternsViewState copyWith({
    ItemListViewState<PatternTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return RelatedPatternsViewState(
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultRelatedPatternsViewState = RelatedPatternsViewState(
  itemsList: defaultPatternsListViewState,
  backgroundBlobs: IList.empty(),
);
