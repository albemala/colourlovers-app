import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

@immutable
class FavoritesFiltersViewState extends Equatable {
  final FavoriteItemTypeFilter typeFilter;
  final FavoriteSortBy sortBy;
  final FavoriteSortOrder sortOrder;
  final IList<BackgroundBlob> backgroundBlobs;

  const FavoritesFiltersViewState({
    required this.typeFilter,
    required this.sortBy,
    required this.sortOrder,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [typeFilter, sortBy, sortOrder, backgroundBlobs];

  FavoritesFiltersViewState copyWith({
    FavoriteItemTypeFilter? typeFilter,
    FavoriteSortBy? sortBy,
    FavoriteSortOrder? sortOrder,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return FavoritesFiltersViewState(
      typeFilter: typeFilter ?? this.typeFilter,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }

  factory FavoritesFiltersViewState.initial() {
    return const FavoritesFiltersViewState(
      typeFilter: FavoriteItemTypeFilter.all,
      sortBy: FavoriteSortBy.timeAdded,
      sortOrder: FavoriteSortOrder.descending,
      backgroundBlobs: IList.empty(),
    );
  }
}
