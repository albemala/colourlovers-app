import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/palette-filters/data-controller.dart';
import 'package:colourlovers_app/palette-filters/data-state.dart';
import 'package:colourlovers_app/palette-filters/view.dart';
import 'package:colourlovers_app/palettes/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PalettesViewController extends Cubit<PalettesViewState> {
  final ColourloversApiClient _client;
  final PaletteFiltersDataController dataController;

  late final ItemsPagination<ColourloversPalette> _pagination;

  StreamSubscription<PaletteFiltersDataState>? _dataControllerSubscription;

  factory PalettesViewController.fromContext(BuildContext context) {
    return PalettesViewController(
      ColourloversApiClient(),
      context.read<PaletteFiltersDataController>(),
    );
  }

  PalettesViewController(
    this._client,
    this.dataController,
  ) : super(defaultPalettesViewState) {
    _dataControllerSubscription = dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      final lover = dataController.userName;
      final hueRanges = dataController.colorFilter == ColorFilter.hueRanges
          ? dataController.hueRanges.toList()
          : <ColourloversRequestHueRange>[];
      final hex = dataController.colorFilter == ColorFilter.hex
          ? [dataController.hex]
          : <String>[];
      final keywords = dataController.paletteName;

      switch (dataController.showCriteria) {
        case ContentShowCriteria.newest:
          return _client.getNewPalettes(
            lover: lover,
            hueRanges: hueRanges,
            hex: hex,
            keywords: keywords,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.top:
          return _client.getTopPalettes(
            lover: lover,
            hueRanges: hueRanges,
            hex: hex,
            keywords: keywords,
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.all:
          return _client.getPalettes(
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

  void showPaletteFilters(
    BuildContext context,
  ) {
    openScreen(
      context,
      const PaletteFiltersViewCreator(),
      isFullscreenDialog: true,
    );
  }

  void showPaletteDetails(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final palette = _pagination.items[index];
    _showPaletteDetails(context, palette);
  }

  Future<void> showRandomPalette(
    BuildContext context,
  ) async {
    final palette = await _client.getRandomPalette();
    if (palette == null) return;
    _showPaletteDetails(context, palette);
  }

  void _showPaletteDetails(
    BuildContext context,
    ColourloversPalette palette,
  ) {
    openScreen(context, PaletteDetailsViewCreator(palette: palette));
  }

  void _updateState() {
    emit(
      PalettesViewState(
        showCriteria: dataController.showCriteria,
        sortBy: dataController.sortBy,
        sortOrder: dataController.sortOrder,
        colorFilter: dataController.colorFilter,
        hueRanges: dataController.hueRanges,
        hex: dataController.hex,
        paletteName: dataController.paletteName,
        userName: dataController.userName,
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items: _pagination.items
              .map(PaletteTileViewState.fromColourloverPalette)
              .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
