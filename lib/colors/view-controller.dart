import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/color-filters/view.dart';
import 'package:colourlovers_app/colors/view-state.dart';
import 'package:colourlovers_app/item-filters/defines.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsViewController extends Cubit<ColorsViewState> {
  factory ColorsViewController.fromContext(BuildContext context) {
    return ColorsViewController(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  late ColorFiltersViewState _filters;
  late final ItemsPagination<ColourloversColor> _pagination;

  ColorsViewController(
    this._client,
  ) : super(
          ColorsViewState.initialState(),
        ) {
    _filters = state.filters;

    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      switch (_filters.filter) {
        case ItemsFilter.newest:
          return _client.getNewColors(
            lover: _filters.userName,
            hueMin: _filters.hueMin,
            hueMax: _filters.hueMax,
            brightnessMin: _filters.brightnessMin,
            brightnessMax: _filters.brightnessMax,
            keywords: _filters.colorName,
            numResults: numResults,
            resultOffset: offset,
          );
        case ItemsFilter.top:
          return _client.getTopColors(
            lover: _filters.userName,
            hueMin: _filters.hueMin,
            hueMax: _filters.hueMax,
            brightnessMin: _filters.brightnessMin,
            brightnessMax: _filters.brightnessMax,
            keywords: _filters.colorName,
          );
        case ItemsFilter.all:
          return _client.getColors(
            lover: _filters.userName,
            hueMin: _filters.hueMin,
            hueMax: _filters.hueMax,
            brightnessMin: _filters.brightnessMin,
            brightnessMax: _filters.brightnessMax,
            keywords: _filters.colorName,
            sortBy: _filters.order,
            orderBy: _filters.sortBy,
          );
      }
    });
    _pagination.addListener(_updateState);
    _pagination.load();
  }

  @override
  Future<void> close() {
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
      ColorFiltersViewCreator(
        initialState: _filters,
        onApply: (filters) {
          closeCurrentView(context);
          _filters = filters;
          _pagination.reset();
          _updateState();
          _pagination.load();
        },
      ),
      // fullscreenDialog: true, // TODO
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
        filters: _filters,
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items: _pagination.items //
              .map(ColorTileViewState.fromColourloverColor)
              .toList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
