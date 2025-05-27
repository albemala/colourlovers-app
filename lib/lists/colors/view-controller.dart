import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/filters/color/data-controller.dart';
import 'package:colourlovers_app/filters/color/data-state.dart';
import 'package:colourlovers_app/filters/color/view.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/lists/colors/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsViewController extends Cubit<ColorsViewState> {
  final ColourloversApiClient _client;
  final ColorFiltersDataController _dataController;

  late final ItemsPagination<ColourloversColor> _pagination;

  StreamSubscription<ColorFiltersDataState>? _dataControllerSubscription;

  factory ColorsViewController.fromContext(BuildContext context) {
    return ColorsViewController(
      ColourloversApiClient(),
      context.read<ColorFiltersDataController>(),
    );
  }

  ColorsViewController(this._client, this._dataController)
    : super(defaultColorsViewState) {
    _dataControllerSubscription = _dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });

    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      switch (_dataController.showCriteria) {
        case ContentShowCriteria.newest:
          return _client.getNewColors(
            lover: _dataController.userName,
            hueMin: _dataController.hueMin,
            hueMax: _dataController.hueMax,
            brightnessMin: _dataController.brightnessMin,
            brightnessMax: _dataController.brightnessMax,
            keywords: _dataController.colorName,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.top:
          return _client.getTopColors(
            lover: _dataController.userName,
            hueMin: _dataController.hueMin,
            hueMax: _dataController.hueMax,
            brightnessMin: _dataController.brightnessMin,
            brightnessMax: _dataController.brightnessMax,
            keywords: _dataController.colorName,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.all:
          return _client.getColors(
            lover: _dataController.userName,
            hueMin: _dataController.hueMin,
            hueMax: _dataController.hueMax,
            brightnessMin: _dataController.brightnessMin,
            brightnessMax: _dataController.brightnessMax,
            keywords: _dataController.colorName,
            sortBy: _dataController.sortOrder,
            orderBy: _dataController.sortBy,
            numResults: numResults,
            resultOffset: offset,
          );
      }
    });
    _pagination
      ..addListener(_updateState)
      ..load();

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
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

  void showColorFilters(BuildContext context) {
    openScreen<void>(
      context,
      const ColorFiltersViewCreator(),
      fullscreenDialog: true,
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

  Future<void> showRandomColor(BuildContext context) async {
    final color = await _client.getRandomColor();
    if (color == null) return;
    _showColorDetails(context, color);
  }

  void _showColorDetails(BuildContext context, ColourloversColor color) {
    openScreen<void>(context, ColorDetailsViewCreator(color: color));
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _dataController.showCriteria,
        sortBy: _dataController.sortBy,
        sortOrder: _dataController.sortOrder,
        hueMin: _dataController.hueMin,
        hueMax: _dataController.hueMax,
        brightnessMin: _dataController.brightnessMin,
        brightnessMax: _dataController.brightnessMax,
        colorName: _dataController.colorName,
        userName: _dataController.userName,
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items:
              _pagination
                  .items //
                  .map(ColorTileViewState.fromColourloverColor)
                  .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
