import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/user/data-controller.dart';
import 'package:colourlovers_app/filters/user/data-state.dart';
import 'package:colourlovers_app/filters/user/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFiltersViewController extends Cubit<UserFiltersViewState> {
  final UserFiltersDataController _dataController;

  var _showCriteria = defaultUserFiltersViewState.showCriteria;
  var _sortBy = defaultUserFiltersViewState.sortBy;
  var _sortOrder = defaultUserFiltersViewState.sortOrder;
  var _userName = defaultUserFiltersViewState.userName;

  factory UserFiltersViewController.fromContext(BuildContext context) {
    return UserFiltersViewController(context.read<UserFiltersDataController>());
  }

  UserFiltersViewController(this._dataController)
    : super(defaultUserFiltersViewState) {
    _showCriteria = _dataController.showCriteria;
    _sortBy = _dataController.sortBy;
    _sortOrder = _dataController.sortOrder;
    _userName = _dataController.userName;

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _updateState();
  }


  void setShowCriteria(ContentShowCriteria value) {
    _showCriteria = value;
    _updateState();
  }

  void setSortBy(ColourloversRequestOrderBy value) {
    _sortBy = value;
    _updateState();
  }

  void setOrder(ColourloversRequestSortBy value) {
    _sortOrder = value;
    _updateState();
  }

  void setUserName(String value) {
    _userName = value;
    _updateState();
  }

  void pickHex(BuildContext context) {}

  void resetFilters() {
    _showCriteria = defaultUserFiltersDataState.showCriteria;
    _sortBy = defaultUserFiltersDataState.sortBy;
    _sortOrder = defaultUserFiltersDataState.sortOrder;
    _userName = defaultUserFiltersDataState.userName;
    _updateState();
  }

  void applyFilters() {
    _dataController
      ..showCriteria = _showCriteria
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder
      ..userName = _userName;
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _showCriteria,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        userName: _userName,
      ),
    );
  }
}
