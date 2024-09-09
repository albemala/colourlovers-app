import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/item-filters/defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorFiltersViewController extends Cubit<ColorFiltersViewState> {
  factory ColorFiltersViewController.fromContext(
    BuildContext context, {
    required ColorFiltersViewState initialState,
    required void Function(ColorFiltersViewState) onApply,
  }) {
    return ColorFiltersViewController(
      initialState,
      onApply,
    );
  }

  final void Function(ColorFiltersViewState) onApply;

  late ItemsFilter _filter;
  late ColourloversRequestOrderBy _sortBy;
  late ColourloversRequestSortBy _order;
  late int _hueMin;
  late int _hueMax;
  late int _brightnessMin;
  late int _brightnessMax;
  final colorNameController = TextEditingController();
  final userNameController = TextEditingController();

  ColorFiltersViewController(
    super.initialState,
    this.onApply,
  ) {
    _filter = state.filter;
    _sortBy = state.sortBy;
    _order = state.order;
    _hueMin = state.hueMin;
    _hueMax = state.hueMax;
    _brightnessMin = state.brightnessMin;
    _brightnessMax = state.brightnessMax;
    colorNameController.value = TextEditingValue(
      text: state.colorName,
      selection: colorNameController.selection,
    );
    userNameController.value = TextEditingValue(
      text: state.userName,
      selection: userNameController.selection,
    );
  }

  @override
  Future<void> close() {
    colorNameController.dispose();
    userNameController.dispose();
    return super.close();
  }

  void setFilter(ItemsFilter value) {
    _filter = value;
    _updateState();
  }

  void setSortBy(ColourloversRequestOrderBy value) {
    _sortBy = value;
    _updateState();
  }

  void setOrder(ColourloversRequestSortBy value) {
    _order = value;
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
    colorNameController.value = TextEditingValue(
      text: value,
      selection: colorNameController.selection,
    );
    _updateState();
  }

  void setUserName(String value) {
    userNameController.value = TextEditingValue(
      text: value,
      selection: userNameController.selection,
    );
    _updateState();
  }

  void _updateState() {
    emit(
      ColorFiltersViewState(
        filter: _filter,
        sortBy: _sortBy,
        order: _order,
        hueMin: _hueMin,
        hueMax: _hueMax,
        brightnessMin: _brightnessMin,
        brightnessMax: _brightnessMax,
        colorName: colorNameController.text,
        userName: userNameController.text,
      ),
    );
  }
}
