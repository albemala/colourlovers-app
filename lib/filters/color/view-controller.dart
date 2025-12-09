import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/color/data-controller.dart';
import 'package:colourlovers_app/filters/color/data-state.dart';
import 'package:colourlovers_app/filters/color/view-state.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _initialColorFilters = ColorFiltersDataState.initial();

class ColorFiltersViewController extends Cubit<ColorFiltersViewState> {
  final ColorFiltersDataController _dataController;

  var _showCriteria = _initialColorFilters.showCriteria;
  var _sortBy = _initialColorFilters.sortBy;
  var _sortOrder = _initialColorFilters.sortOrder;
  var _hueMin = _initialColorFilters.hueMin;
  var _hueMax = _initialColorFilters.hueMax;
  var _brightnessMin = _initialColorFilters.brightnessMin;
  var _brightnessMax = _initialColorFilters.brightnessMax;
  var _colorName = _initialColorFilters.colorName;
  var _userName = _initialColorFilters.userName;

  factory ColorFiltersViewController.fromContext(BuildContext context) {
    return ColorFiltersViewController(
      context.read<ColorFiltersDataController>(),
    );
  }

  ColorFiltersViewController(this._dataController)
    : super(ColorFiltersViewState.initial()) {
    _showCriteria = _dataController.showCriteria;
    _sortBy = _dataController.sortBy;
    _sortOrder = _dataController.sortOrder;
    _hueMin = _dataController.hueMin;
    _hueMax = _dataController.hueMax;
    _brightnessMin = _dataController.brightnessMin;
    _brightnessMax = _dataController.brightnessMax;
    _colorName = _dataController.colorName;
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

  void setHueMin(int value) {
    _hueMin = value;
    _updateState();
  }

  void setHueMax(int value) {
    _hueMax = value;
    _updateState();
  }

  void setBrightnessMin(int value) {
    _brightnessMin = value;
    _updateState();
  }

  void setBrightnessMax(int value) {
    _brightnessMax = value;
    _updateState();
  }

  void setColorName(String value) {
    _colorName = value;
    _updateState();
  }

  void setUserName(String value) {
    _userName = value;
    _updateState();
  }

  void resetFilters() {
    _showCriteria = _initialColorFilters.showCriteria;
    _sortBy = _initialColorFilters.sortBy;
    _sortOrder = _initialColorFilters.sortOrder;
    _hueMin = _initialColorFilters.hueMin;
    _hueMax = _initialColorFilters.hueMax;
    _brightnessMin = _initialColorFilters.brightnessMin;
    _brightnessMax = _initialColorFilters.brightnessMax;
    _colorName = _initialColorFilters.colorName;
    _userName = _initialColorFilters.userName;
    _updateState();
  }

  void applyFilters() {
    _dataController
      ..showCriteria = _showCriteria
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder
      ..hueMin = _hueMin
      ..hueMax = _hueMax
      ..brightnessMin = _brightnessMin
      ..brightnessMax = _brightnessMax
      ..colorName = _colorName
      ..userName = _userName;
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _showCriteria,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        hueMin: _hueMin,
        hueMax: _hueMax,
        brightnessMin: _brightnessMin,
        brightnessMax: _brightnessMax,
        colorName: _colorName,
        userName: _userName,
      ),
    );
  }
}
