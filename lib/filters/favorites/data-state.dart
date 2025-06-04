import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class FavoritesFiltersDataState extends Equatable {
  final FavoriteItemTypeFilter typeFilter;
  final FavoriteSortBy sortBy;
  final FavoriteSortOrder sortOrder;

  const FavoritesFiltersDataState({
    required this.typeFilter,
    required this.sortBy,
    required this.sortOrder,
  });

  @override
  List<Object> get props => [typeFilter, sortBy, sortOrder];

  FavoritesFiltersDataState copyWith({
    FavoriteItemTypeFilter? typeFilter,
    FavoriteSortBy? sortBy,
    FavoriteSortOrder? sortOrder,
  }) {
    return FavoritesFiltersDataState(
      typeFilter: typeFilter ?? this.typeFilter,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeFilter': typeFilter.name,
      'sortBy': sortBy.name,
      'sortOrder': sortOrder.name,
    };
  }

  factory FavoritesFiltersDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'typeFilter': final String typeFilter,
        'sortBy': final String sortBy,
        'sortOrder': final String sortOrder,
      } =>
        FavoritesFiltersDataState(
          typeFilter: FavoriteItemTypeFilter.values.byName(typeFilter),
          sortBy: FavoriteSortBy.values.byName(sortBy),
          sortOrder: FavoriteSortOrder.values.byName(sortOrder),
        ),
      _ => defaultFavoritesFiltersDataState,
    };
  }
}

const defaultFavoritesFiltersDataState = FavoritesFiltersDataState(
  typeFilter: FavoriteItemTypeFilter.all,
  sortBy: FavoriteSortBy.timeAdded,
  sortOrder: FavoriteSortOrder.descending,
);
