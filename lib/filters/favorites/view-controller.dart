import 'package:colourlovers_app/filters/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/favorites/data-state.dart';
import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/filters/favorites/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesFiltersViewController extends Cubit<FavoritesFiltersViewState> {
  final FavoritesFiltersDataController _dataController;

  var _typeFilter = defaultFavoritesFiltersDataState.typeFilter;
  var _sortBy = defaultFavoritesFiltersDataState.sortBy;
  var _sortOrder = defaultFavoritesFiltersDataState.sortOrder;

  factory FavoritesFiltersViewController.fromContext(BuildContext context) {
    return FavoritesFiltersViewController(
      context.read<FavoritesFiltersDataController>(),
    );
  }

  FavoritesFiltersViewController(this._dataController)
    : super(defaultFavoritesFiltersViewState) {
    _typeFilter = _dataController.typeFilter;
    _sortBy = _dataController.sortBy;
    _sortOrder = _dataController.sortOrder;

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _updateState();
  }

  void setTypeFilter(FavoriteItemTypeFilter value) {
    _typeFilter = value;
    _updateState();
  }

  void setSortBy(FavoriteSortBy value) {
    _sortBy = value;
    _updateState();
  }

  void setSortOrder(FavoriteSortOrder value) {
    _sortOrder = value;
    _updateState();
  }

  void resetFilters() {
    _typeFilter = defaultFavoritesFiltersDataState.typeFilter;
    _sortBy = defaultFavoritesFiltersDataState.sortBy;
    _sortOrder = defaultFavoritesFiltersDataState.sortOrder;
    _updateState();
  }

  void applyFilters() {
    _dataController
      ..typeFilter = _typeFilter
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder;
  }

  void _updateState() {
    emit(
      state.copyWith(
        typeFilter: _typeFilter,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }
}
