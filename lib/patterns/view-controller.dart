import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/pattern-filters/data-controller.dart';
import 'package:colourlovers_app/pattern-filters/data-state.dart';
import 'package:colourlovers_app/pattern-filters/view.dart';
import 'package:colourlovers_app/patterns/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternsViewController extends Cubit<PatternsViewState> {
  final ColourloversApiClient _client;
  final PatternFiltersDataController dataController;

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
    this.dataController,
  ) : super(defaultPatternsViewState) {
    _dataControllerSubscription = dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      final lover = dataController.userName;
      final hueRanges = dataController.colorFilter == ColorFilter.hueRanges
          ? dataController.hueRanges.toList()
          : <ColourloversRequestHueRange>[];
      final hex = dataController.colorFilter == ColorFilter.hex
          ? [dataController.hex]
          : <String>[];
      final keywords = dataController.patternName;

      switch (dataController.showCriteria) {
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

  void showPatternFilters(
    BuildContext context,
  ) {
    openScreen(
      context,
      const PatternFiltersViewCreator(),
      isFullscreenDialog: true,
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
      PatternsViewState(
        showCriteria: dataController.showCriteria,
        sortBy: dataController.sortBy,
        sortOrder: dataController.sortOrder,
        colorFilter: dataController.colorFilter,
        hueRanges: dataController.hueRanges,
        hex: dataController.hex,
        patternName: dataController.patternName,
        userName: dataController.userName,
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
