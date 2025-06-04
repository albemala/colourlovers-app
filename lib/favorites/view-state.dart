import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class FavoritesViewState extends Equatable {
  final IList<BackgroundBlob> backgroundBlobs;
  final IList<Equatable> items;
  final FavoriteItemTypeFilter typeFilter;
  final FavoriteSortBy sortBy;
  final FavoriteSortOrder sortOrder;

  const FavoritesViewState({
    required this.backgroundBlobs,
    required this.items,
    required this.typeFilter,
    required this.sortBy,
    required this.sortOrder,
  });

  @override
  List<Object> get props => [
    backgroundBlobs,
    items,
    typeFilter,
    sortBy,
    sortOrder,
  ];

  FavoritesViewState copyWith({
    IList<BackgroundBlob>? backgroundBlobs,
    IList<Equatable>? items,
    FavoriteItemTypeFilter? typeFilter,
    FavoriteSortBy? sortBy,
    FavoriteSortOrder? sortOrder,
  }) {
    return FavoritesViewState(
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
      items: items ?? this.items,
      typeFilter: typeFilter ?? this.typeFilter,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

const defaultFavoritesViewState = FavoritesViewState(
  backgroundBlobs: IList.empty(),
  items: IList.empty(),
  typeFilter: FavoriteItemTypeFilter.all,
  sortBy: FavoriteSortBy.timeAdded,
  sortOrder: FavoriteSortOrder.descending,
);
