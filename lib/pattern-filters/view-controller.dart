import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/pattern-filters/data-controller.dart';
import 'package:colourlovers_app/pattern-filters/data-state.dart';
import 'package:colourlovers_app/pattern-filters/view-state.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternFiltersViewController extends Cubit<PatternFiltersViewState> {
  final PatternFiltersDataController dataController;

  var _showCriteria = defaultPatternFiltersViewState.showCriteria;
  var _sortBy = defaultPatternFiltersViewState.sortBy;
  var _sortOrder = defaultPatternFiltersViewState.sortOrder;
  var _colorFilter = defaultPatternFiltersViewState.colorFilter;
  var _hueRanges = defaultPatternFiltersViewState.hueRanges;
  final hexController = TextEditingController();
  final patternNameController = TextEditingController();
  final userNameController = TextEditingController();

  factory PatternFiltersViewController.fromContext(BuildContext context) {
    return PatternFiltersViewController(
      context.read<PatternFiltersDataController>(),
    );
  }

  PatternFiltersViewController(
    this.dataController,
  ) : super(defaultPatternFiltersViewState) {
    _showCriteria = dataController.showCriteria;
    _sortBy = dataController.sortBy;
    _sortOrder = dataController.sortOrder;
    _colorFilter = dataController.colorFilter;
    _hueRanges = dataController.hueRanges;
    hexController.text = dataController.hex;
    patternNameController.value = TextEditingValue(
      text: dataController.patternName,
    );
    userNameController.value = TextEditingValue(
      text: dataController.userName,
    );
    _updateState();
  }

  @override
  Future<void> close() {
    hexController.dispose();
    patternNameController.dispose();
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
          createGenericSnackBar(
            message: 'You can select up to 5 hue ranges',
          ),
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
    _showCriteria = defaultPatternFiltersDataState.showCriteria;
    _sortBy = defaultPatternFiltersDataState.sortBy;
    _sortOrder = defaultPatternFiltersDataState.sortOrder;
    _colorFilter = defaultPatternFiltersDataState.colorFilter;
    _hueRanges = defaultPatternFiltersDataState.hueRanges;
    hexController.value = TextEditingValue(
      text: defaultPatternFiltersDataState.hex,
    );
    patternNameController.value = TextEditingValue(
      text: defaultPatternFiltersDataState.patternName,
    );
    userNameController.value = TextEditingValue(
      text: defaultPatternFiltersDataState.userName,
    );
    _updateState();
  }

  void applyFilters() {
    dataController
      ..showCriteria = _showCriteria
      ..sortBy = _sortBy
      ..sortOrder = _sortOrder
      ..colorFilter = _colorFilter
      ..hueRanges = _hueRanges
      ..hex = hexController.text
      ..patternName = patternNameController.text
      ..userName = userNameController.text;
  }

  void _updateState() {
    emit(
      PatternFiltersViewState(
        showCriteria: _showCriteria,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        colorFilter: _colorFilter,
        hueRanges: _hueRanges,
      ),
    );
  }
}
