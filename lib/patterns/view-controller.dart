import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/pattern-filters/data-controller.dart';
import 'package:colourlovers_app/pattern-filters/data-state.dart';
import 'package:colourlovers_app/pattern-filters/view.dart';
import 'package:colourlovers_app/patterns/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternsViewController extends Cubit<PatternsViewState> {
  final ColourloversApiClient _client;
  final PatternFiltersDataController _dataController;

  late final ItemsPagination<ColourloversPattern> _pagination;

  StreamSubscription<PatternFiltersDataState>? _dataControllerSubscription;

  factory PatternsViewController.fromContext(BuildContext context) {
    return PatternsViewController(
      ColourloversApiClient(),
      context.read<PatternFiltersDataController>(),
    );
  }

  PatternsViewController(
    this._client,
    this._dataController,
  ) : super(defaultPatternsViewState) {
    _dataControllerSubscription = _dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });

    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      final lover = _dataController.userName;
      final hueRanges = _dataController.colorFilter == ColorFilter.hueRanges
          ? _dataController.hueRanges.toList()
          : <ColourloversRequestHueRange>[];
      final hex = _dataController.colorFilter == ColorFilter.hex
          ? [_dataController.hex]
          : <String>[];
      final keywords = _dataController.patternName;

      switch (_dataController.showCriteria) {
        case ContentShowCriteria.newest:
          return _client.getNewPatterns(
            lover: lover,
            hueRanges: hueRanges,
            hex: hex,
            keywords: keywords,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.top:
          return _client.getTopPatterns(
            lover: lover,
            hueRanges: hueRanges,
            hex: hex,
            keywords: keywords,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.all:
          return _client.getPatterns(
            lover: lover,
            hueRanges: hueRanges,
            hex: hex,
            keywords: keywords,
            sortBy: _dataController.sortOrder,
            orderBy: _dataController.sortBy,
            numResults: numResults,
            resultOffset: offset,
          );
      }
    });
    _pagination.addListener(_updateState);
    _pagination.load();

    emit(state.copyWith(
        backgroundBlobs:
            generateBackgroundBlobs(getRandomPalette()).toIList()));
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

  void showPatternFilters(
    BuildContext context,
  ) {
    openScreen(
      context,
      const PatternFiltersViewCreator(),
      fullscreenDialog: true,
    );
  }

  void showPatternDetails(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final pattern = _pagination.items[index];
    _showPatternDetails(context, pattern);
  }

  Future<void> showRandomPattern(
    BuildContext context,
  ) async {
    final pattern = await _client.getRandomPattern();
    if (pattern == null) return;
    _showPatternDetails(context, pattern);
  }

  void _showPatternDetails(
    BuildContext context,
    ColourloversPattern pattern,
  ) {
    openScreen(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _dataController.showCriteria,
        sortBy: _dataController.sortBy,
        sortOrder: _dataController.sortOrder,
        colorFilter: _dataController.colorFilter,
        hueRanges: _dataController.hueRanges,
        hex: _dataController.hex,
        patternName: _dataController.patternName,
        userName: _dataController.userName,
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items: _pagination.items
              .map(PatternTileViewState.fromColourloverPattern)
              .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
