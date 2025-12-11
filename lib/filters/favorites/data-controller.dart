import 'package:colourlovers_app/filters/favorites/data-state.dart';
import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

class FavoritesFiltersDataController
    extends StoredCubit<FavoritesFiltersDataState> {
  FavoritesFiltersDataController() : super(FavoritesFiltersDataState.initial());

  factory FavoritesFiltersDataController.fromContext(BuildContext _) {
    return FavoritesFiltersDataController();
  }

  @override
  Future<void> migrateData() async {}

  @override
  String get storeName => 'favorites_filters';

  @override
  FavoritesFiltersDataState fromMap(Map<String, dynamic> json) {
    return FavoritesFiltersDataState.fromMap(json);
  }

  @override
  Map<String, dynamic> toMap(FavoritesFiltersDataState state) {
    return state.toMap();
  }

  FavoriteItemTypeFilter get typeFilter => state.typeFilter;
  set typeFilter(FavoriteItemTypeFilter value) =>
      emit(state.copyWith(typeFilter: value));

  FavoriteSortBy get sortBy => state.sortBy;
  set sortBy(FavoriteSortBy value) => emit(state.copyWith(sortBy: value));

  FavoriteSortOrder get sortOrder => state.sortOrder;
  set sortOrder(FavoriteSortOrder value) =>
      emit(state.copyWith(sortOrder: value));
}
