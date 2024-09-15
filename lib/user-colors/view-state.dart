import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class UserColorsViewState extends Equatable {
  final ItemsListViewState<ColorTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const UserColorsViewState({
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [
        itemsList,
        backgroundBlobs,
      ];

  UserColorsViewState copyWith({
    ItemsListViewState<ColorTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return UserColorsViewState(
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultUserColorsViewState = UserColorsViewState(
  itemsList: defaultColorsListViewState,
  backgroundBlobs: IList.empty(),
);
