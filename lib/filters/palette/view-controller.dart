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

final _initialPaletteFilters = PaletteFiltersDataState.initial();

class PaletteFiltersViewController extends Cubit<PaletteFiltersViewState> {
  final PaletteFiltersDataController _dataController;

  var _showCriteria = _initialPaletteFilters.showCriteria;
  var _sortBy = _initialPaletteFilters.sortBy;
  var _sortOrder = _initialPaletteFilters.sortOrder;
  var _colorFilter = _initialPaletteFilters.colorFilter;
  var _hueRanges = _initialPaletteFilters.hueRanges;
  var _hex = _initialPaletteFilters.hex;
  var _paletteName = _initialPaletteFilters.paletteName;
  var _userName = _initialPaletteFilters.userName;

  factory PaletteFiltersViewController.fromContext(BuildContext context) {
    return PaletteFiltersViewController(
      context.read<PaletteFiltersDataController>(),
    );
  }

  PaletteFiltersViewController(this._dataController)
    : super(PaletteFiltersViewState.initial()) {
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
    updateViewState();
  }

  void setShowCriteria(ContentShowCriteria value) {
    _showCriteria = value;
    updateViewState();
  }

  void setSortBy(ColourloversRequestOrderBy value) {
    _sortBy = value;
    updateViewState();
  }

  void setOrder(ColourloversRequestSortBy value) {
    _sortOrder = value;
    updateViewState();
  }

  void setColorFilter(ColorFilter value) {
    _colorFilter = value;
    updateViewState();
  }

  void setHueRanges(IList<ColourloversRequestHueRange> value) {
    _hueRanges = value;
    updateViewState();
  }

  void addHueRange(BuildContext context, ColourloversRequestHueRange hueRange) {
    if (!_hueRanges.contains(hueRange)) {
      if (_hueRanges.length < 5) {
        _hueRanges = _hueRanges.add(hueRange);
        updateViewState();
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
      updateViewState();
    }
  }

  void setHex(String value) {
    _hex = value;
    updateViewState();
  }

  void setPaletteName(String value) {
    _paletteName = value;
    updateViewState();
  }

  void setUserName(String value) {
    _userName = value;
    updateViewState();
  }

  void pickHex(BuildContext context) {}

  void resetFilters() {
    _showCriteria = _initialPaletteFilters.showCriteria;
    _sortBy = _initialPaletteFilters.sortBy;
    _sortOrder = _initialPaletteFilters.sortOrder;
    _colorFilter = _initialPaletteFilters.colorFilter;
    _hueRanges = _initialPaletteFilters.hueRanges;
    _hex = _initialPaletteFilters.hex;
    _paletteName = _initialPaletteFilters.paletteName;
    _userName = _initialPaletteFilters.userName;
    updateViewState();
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

  void updateViewState() {
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
