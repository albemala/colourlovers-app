import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class FavoritesViewState extends Equatable {
  final IList<BackgroundBlob> backgroundBlobs;
  final IList<Equatable> items;

  const FavoritesViewState({
    required this.backgroundBlobs,
    required this.items,
  });

  @override
  List<Object> get props => [backgroundBlobs, items];

  FavoritesViewState copyWith({
    IList<BackgroundBlob>? backgroundBlobs,
    IList<Equatable>? items,
  }) {
    return FavoritesViewState(
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
      items: items ?? this.items,
    );
  }
}

const defaultFavoritesViewState = FavoritesViewState(
  backgroundBlobs: IList.empty(),
  items: IList.empty(),
);
