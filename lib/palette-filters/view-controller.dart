import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/palette-filters/data-controller.dart';
import 'package:colourlovers_app/palette-filters/data-state.dart';
import 'package:colourlovers_app/palette-filters/view-state.dart';
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
  final hexController = TextEditingController();
  final paletteNameController = TextEditingController();
  final userNameController = TextEditingController();

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
    hexController.text = _dataController.hex;
    paletteNameController.value = TextEditingValue(
      text: _dataController.paletteName,
    );
    userNameController.value = TextEditingValue(text: _dataController.userName);

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _updateState();
  }

  @override
  Future<void> close() {
    hexController.dispose();
    paletteNameController.dispose();
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

  void pickHex(BuildContext context) {}

  void resetFilters() {
    _showCriteria = defaultPaletteFiltersDataState.showCriteria;
    _sortBy = defaultPaletteFiltersDataState.sortBy;
    _sortOrder = defaultPaletteFiltersDataState.sortOrder;
    _colorFilter = defaultPaletteFiltersDataState.colorFilter;
    _hueRanges = defaultPaletteFiltersDataState.hueRanges;
    hexController.value = TextEditingValue(
      text: defaultPaletteFiltersDataState.hex,
    );
    paletteNameController.value = TextEditingValue(
      text: defaultPaletteFiltersDataState.paletteName,
    );
    userNameController.value = TextEditingValue(
      text: defaultPaletteFiltersDataState.userName,
    );
    _updateState();
  }

  void applyFilters() {
    _dataController
      ..showCriteria = _showCriteria
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder
      ..colorFilter = _colorFilter
      ..hueRanges = _hueRanges
      ..hex = hexController.text
      ..paletteName = paletteNameController.text
      ..userName = userNameController.text;
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _showCriteria,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        colorFilter: _colorFilter,
        hueRanges: _hueRanges,
      ),
    );
  }
}
