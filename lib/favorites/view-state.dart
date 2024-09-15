import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class FavoritesViewState extends Equatable {
  final IList<BackgroundBlob> backgroundBlobs;

  const FavoritesViewState({
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [
        backgroundBlobs,
      ];

  FavoritesViewState copyWith({
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return FavoritesViewState(
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultFavoritesViewState = FavoritesViewState(
  backgroundBlobs: IList.empty(),
);
