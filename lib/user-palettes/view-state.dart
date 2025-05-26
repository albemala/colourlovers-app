import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class UserPalettesViewState extends Equatable {
  final ItemsListViewState<PaletteTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const UserPalettesViewState({
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [itemsList, backgroundBlobs];

  UserPalettesViewState copyWith({
    ItemsListViewState<PaletteTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return UserPalettesViewState(
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultUserPalettesViewState = UserPalettesViewState(
  itemsList: defaultPalettesListViewState,
  backgroundBlobs: IList.empty(),
);
