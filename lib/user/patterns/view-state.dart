import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class UserPatternsViewState extends Equatable {
  final ItemListViewState<PatternTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const UserPatternsViewState({
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [itemsList, backgroundBlobs];

  UserPatternsViewState copyWith({
    ItemListViewState<PatternTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return UserPatternsViewState(
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }

  factory UserPatternsViewState.initial() {
    return UserPatternsViewState(
      itemsList: ItemListViewState<PatternTileViewState>.initial(),
      backgroundBlobs: const IList.empty(),
    );
  }
}
