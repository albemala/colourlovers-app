import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/color-filters/data-controller.dart';
import 'package:colourlovers_app/color-filters/data-state.dart';
import 'package:colourlovers_app/color-filters/view.dart';
import 'package:colourlovers_app/colors/view-state.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsViewController extends Cubit<ColorsViewState> {
  final ColourloversApiClient _client;
  final ColorFiltersDataController dataController;

  late final ItemsPagination<ColourloversColor> _pagination;

  StreamSubscription<ColorFiltersDataState>? _dataControllerSubscription;

  factory ColorsViewController.fromContext(BuildContext context) {
    return ColorsViewController(
      ColourloversApiClient(),
      context.read<ColorFiltersDataController>(),
    );
  }

  ColorsViewController(
    this._client,
    this.dataController,
  ) : super(defaultColorsViewState) {
    _dataControllerSubscription = dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      switch (dataController.showCriteria) {
        case ContentShowCriteria.newest:
          return _client.getNewColors(
            lover: dataController.userName,
            hueMin: dataController.hueMin,
            hueMax: dataController.hueMax,
            brightnessMin: dataController.brightnessMin,
            brightnessMax: dataController.brightnessMax,
            keywords: dataController.colorName,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.top:
          return _client.getTopColors(
            lover: dataController.userName,
            hueMin: dataController.hueMin,
            hueMax: dataController.hueMax,
            brightnessMin: dataController.brightnessMin,
            brightnessMax: dataController.brightnessMax,
            keywords: dataController.colorName,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.all:
          return _client.getColors(
            lover: dataController.userName,
            hueMin: dataController.hueMin,
            hueMax: dataController.hueMax,
            brightnessMin: dataController.brightnessMin,
            brightnessMax: dataController.brightnessMax,
            keywords: dataController.colorName,
            sortBy: dataController.sortOrder,
            orderBy: dataController.sortBy,
            numResults: numResults,
            resultOffset: offset,
          );
      }
    });
    _pagination.addListener(_updateState);
    _pagination.load();
  }

  @override
  Future<void> close() {
    _dataControllerSubscription?.cancel();
    _pagination.removeListener(_updateState);
    return super.close();
  }

  Future<void> loadMore() async {
    await _pagination.loadMore();
  }

  void showColorFilters(
    BuildContext context,
  ) {
    openScreen(
      context,
      const ColorFiltersViewCreator(),
      isFullscreenDialog: true,
    );
  }

  void showColorDetails(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final color = _pagination.items[index];
    _showColorDetails(context, color);
  }

  Future<void> showRandomColor(
    BuildContext context,
  ) async {
    final color = await _client.getRandomColor();
    if (color == null) return;
    _showColorDetails(context, color);
  }

  void _showColorDetails(
    BuildContext context,
    ColourloversColor color,
  ) {
    openScreen(context, ColorDetailsViewCreator(color: color));
  }

  void _updateState() {
    emit(
      ColorsViewState(
        showCriteria: dataController.showCriteria,
        sortBy: dataController.sortBy,
        sortOrder: dataController.sortOrder,
        hueMin: dataController.hueMin,
        hueMax: dataController.hueMax,
        brightnessMin: dataController.brightnessMin,
        brightnessMax: dataController.brightnessMax,
        colorName: dataController.colorName,
        userName: dataController.userName,
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items: _pagination.items //
              .map(ColorTileViewState.fromColourloverColor)
              .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
