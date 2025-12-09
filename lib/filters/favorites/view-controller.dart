import 'package:colourlovers_app/filters/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/favorites/data-state.dart';
import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/filters/favorites/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _initialFavoritesFilters = FavoritesFiltersDataState.initial();

class FavoritesFiltersViewController extends Cubit<FavoritesFiltersViewState> {
  final FavoritesFiltersDataController _dataController;

  var _typeFilter = _initialFavoritesFilters.typeFilter;
  var _sortBy = _initialFavoritesFilters.sortBy;
  var _sortOrder = _initialFavoritesFilters.sortOrder;

  factory FavoritesFiltersViewController.fromContext(BuildContext context) {
    return FavoritesFiltersViewController(
      context.read<FavoritesFiltersDataController>(),
    );
  }

  FavoritesFiltersViewController(this._dataController)
    : super(FavoritesFiltersViewState.initial()) {
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
    _typeFilter = _initialFavoritesFilters.typeFilter;
    _sortBy = _initialFavoritesFilters.sortBy;
    _sortOrder = _initialFavoritesFilters.sortOrder;
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
