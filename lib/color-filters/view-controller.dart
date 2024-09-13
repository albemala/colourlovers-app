import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-filters/data-controller.dart';
import 'package:colourlovers_app/color-filters/data-state.dart';
import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorFiltersViewController extends Cubit<ColorFiltersViewState> {
  final ColorFiltersDataController dataController;

  var _showCriteria = defaultColorFiltersViewState.showCriteria;
  var _sortBy = defaultColorFiltersViewState.sortBy;
  var _sortOrder = defaultColorFiltersViewState.sortOrder;
  var _hueMin = defaultColorFiltersViewState.hueMin;
  var _hueMax = defaultColorFiltersViewState.hueMax;
  var _brightnessMin = defaultColorFiltersViewState.brightnessMin;
  var _brightnessMax = defaultColorFiltersViewState.brightnessMax;
  final colorNameController = TextEditingController();
  final userNameController = TextEditingController();

  factory ColorFiltersViewController.fromContext(BuildContext context) {
    return ColorFiltersViewController(
      context.read<ColorFiltersDataController>(),
    );
  }

  ColorFiltersViewController(
    this.dataController,
  ) : super(defaultColorFiltersViewState) {
    _showCriteria = dataController.showCriteria;
    _sortBy = dataController.sortBy;
    _sortOrder = dataController.sortOrder;
    _hueMin = dataController.hueMin;
    _hueMax = dataController.hueMax;
    _brightnessMin = dataController.brightnessMin;
    _brightnessMax = dataController.brightnessMax;
    colorNameController.value = TextEditingValue(
      text: dataController.colorName,
    );
    userNameController.value = TextEditingValue(
      text: dataController.userName,
    );
    _updateState();
  }

  @override
  Future<void> close() {
    colorNameController.dispose();
    userNameController.dispose();
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

  void resetFilters() {
    _showCriteria = defaultColorFiltersDataState.showCriteria;
    _sortBy = defaultColorFiltersDataState.sortBy;
    _sortOrder = defaultColorFiltersDataState.sortOrder;
    _hueMin = defaultColorFiltersDataState.hueMin;
    _hueMax = defaultColorFiltersDataState.hueMax;
    _brightnessMin = defaultColorFiltersDataState.brightnessMin;
    _brightnessMax = defaultColorFiltersDataState.brightnessMax;
    colorNameController.value = TextEditingValue(
      text: defaultColorFiltersDataState.colorName,
    );
    userNameController.value = TextEditingValue(
      text: defaultColorFiltersDataState.userName,
    );
    _updateState();
  }

  void applyFilters() {
    dataController
      ..showCriteria = _showCriteria
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder
      ..hueMin = _hueMin
      ..hueMax = _hueMax
      ..brightnessMin = _brightnessMin
      ..brightnessMax = _brightnessMax
      ..colorName = colorNameController.text
      ..userName = userNameController.text;
  }

  void _updateState() {
    emit(
      ColorFiltersViewState(
        showCriteria: _showCriteria,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        hueMin: _hueMin,
        hueMax: _hueMax,
        brightnessMin: _brightnessMin,
        brightnessMax: _brightnessMax,
      ),
    );
  }
}
