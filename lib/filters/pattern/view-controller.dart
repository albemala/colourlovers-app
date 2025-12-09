import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/pattern/data-controller.dart';
import 'package:colourlovers_app/filters/pattern/data-state.dart';
import 'package:colourlovers_app/filters/pattern/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _initialPatternFilters = PatternFiltersDataState.initial();

class PatternFiltersViewController extends Cubit<PatternFiltersViewState> {
  final PatternFiltersDataController _dataController;

  var _showCriteria = _initialPatternFilters.showCriteria;
  var _sortBy = _initialPatternFilters.sortBy;
  var _sortOrder = _initialPatternFilters.sortOrder;
  var _colorFilter = _initialPatternFilters.colorFilter;
  var _hueRanges = _initialPatternFilters.hueRanges;
  var _hex = _initialPatternFilters.hex;
  var _patternName = _initialPatternFilters.patternName;
  var _userName = _initialPatternFilters.userName;

  factory PatternFiltersViewController.fromContext(BuildContext context) {
    return PatternFiltersViewController(
      context.read<PatternFiltersDataController>(),
    );
  }

  PatternFiltersViewController(this._dataController)
    : super(PatternFiltersViewState.initial()) {
    _showCriteria = _dataController.showCriteria;
    _sortBy = _dataController.sortBy;
    _sortOrder = _dataController.sortOrder;
    _colorFilter = _dataController.colorFilter;
    _hueRanges = _dataController.hueRanges;
    _hex = _dataController.hex;
    _patternName = _dataController.patternName;
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

  void setPatternName(String value) {
    _patternName = value;
    _updateState();
  }

  void setUserName(String value) {
    _userName = value;
    _updateState();
  }

  void pickHex(BuildContext context) {}

  void resetFilters() {
    _showCriteria = _initialPatternFilters.showCriteria;
    _sortBy = _initialPatternFilters.sortBy;
    _sortOrder = _initialPatternFilters.sortOrder;
    _colorFilter = _initialPatternFilters.colorFilter;
    _hueRanges = _initialPatternFilters.hueRanges;
    _hex = _initialPatternFilters.hex;
    _patternName = _initialPatternFilters.patternName;
    _userName = _initialPatternFilters.userName;
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
      ..patternName = _patternName
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
        patternName: _patternName,
        userName: _userName,
      ),
    );
  }
}
