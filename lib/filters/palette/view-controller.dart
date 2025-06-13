import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/palette/data-controller.dart';
import 'package:colourlovers_app/filters/palette/data-state.dart';
import 'package:colourlovers_app/filters/palette/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteFiltersViewController extends Cubit<PaletteFiltersViewState> {
  final PaletteFiltersDataController _dataController;

  var _showCriteria = defaultPaletteFiltersViewState.showCriteria;
  var _sortBy = defaultPaletteFiltersViewState.sortBy;
  var _sortOrder = defaultPaletteFiltersViewState.sortOrder;
  var _colorFilter = defaultPaletteFiltersViewState.colorFilter;
  var _hueRanges = defaultPaletteFiltersViewState.hueRanges;
  var _hex = defaultPaletteFiltersViewState.hex;
  var _paletteName = defaultPaletteFiltersViewState.paletteName;
  var _userName = defaultPaletteFiltersViewState.userName;

  factory PaletteFiltersViewController.fromContext(BuildContext context) {
    return PaletteFiltersViewController(
      context.read<PaletteFiltersDataController>(),
    );
  }

  PaletteFiltersViewController(this._dataController)
    : super(defaultPaletteFiltersViewState) {
    _showCriteria = _dataController.showCriteria;
    _sortBy = _dataController.sortBy;
    _sortOrder = _dataController.sortOrder;
    _colorFilter = _dataController.colorFilter;
    _hueRanges = _dataController.hueRanges;
    _hex = _dataController.hex;
    _paletteName = _dataController.paletteName;
    _userName = _dataController.userName;

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _updateState();
  }

  @override
  Future<void> close() {
    return super.close();
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

  void setColorFilter(ColorFilter value) {
    _colorFilter = value;
    _updateState();
  }

  void setHueRanges(IList<ColourloversRequestHueRange> value) {
    _hueRanges = value;
    _updateState();
  }

  void addHueRange(BuildContext context, ColourloversRequestHueRange hueRange) {
    if (!_hueRanges.contains(hueRange)) {
      if (_hueRanges.length < 5) {
        _hueRanges = _hueRanges.add(hueRange);
        _updateState();
      } else {
        showSnackBar(
          context,
          createGenericSnackBar(message: 'You can select up to 5 hue ranges'),
        );
      }
    }
  }

  void removeHueRange(ColourloversRequestHueRange hueRange) {
    if (_hueRanges.contains(hueRange)) {
      _hueRanges = _hueRanges.remove(hueRange);
      _updateState();
    }
  }

  void setHex(String value) {
    _hex = value;
    _updateState();
  }

  void setPaletteName(String value) {
    _paletteName = value;
    _updateState();
  }

  void setUserName(String value) {
    _userName = value;
    _updateState();
  }

  void pickHex(BuildContext context) {}

  void resetFilters() {
    _showCriteria = defaultPaletteFiltersDataState.showCriteria;
    _sortBy = defaultPaletteFiltersDataState.sortBy;
    _sortOrder = defaultPaletteFiltersDataState.sortOrder;
    _colorFilter = defaultPaletteFiltersDataState.colorFilter;
    _hueRanges = defaultPaletteFiltersDataState.hueRanges;
    _hex = defaultPaletteFiltersDataState.hex;
    _paletteName = defaultPaletteFiltersDataState.paletteName;
    _userName = defaultPaletteFiltersDataState.userName;
    _updateState();
  }

  void applyFilters() {
    _dataController
      ..showCriteria = _showCriteria
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder
      ..colorFilter = _colorFilter
      ..hueRanges = _hueRanges
      ..hex = _hex
      ..paletteName = _paletteName
      ..userName = _userName;
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _showCriteria,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        colorFilter: _colorFilter,
        hueRanges: _hueRanges,
        hex: _hex,
        paletteName: _paletteName,
        userName: _userName,
      ),
    );
  }
}
