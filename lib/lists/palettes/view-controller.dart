import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/palette/data-controller.dart';
import 'package:colourlovers_app/filters/palette/data-state.dart';
import 'package:colourlovers_app/filters/palette/view.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/lists/palettes/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PalettesViewController extends Cubit<PalettesViewState> {
  final ColourloversApiClient _client;
  final PaletteFiltersDataController _dataController;

  late final ItemsPagination<ColourloversPalette> _pagination;

  StreamSubscription<PaletteFiltersDataState>? _dataControllerSubscription;

  factory PalettesViewController.fromContext(BuildContext context) {
    return PalettesViewController(
      ColourloversApiClient(),
      context.read<PaletteFiltersDataController>(),
    );
  }

  PalettesViewController(this._client, this._dataController)
    : super(defaultPalettesViewState) {
    _dataControllerSubscription = _dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });

    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      final lover = _dataController.userName;
      final hueRanges =
          _dataController.colorFilter == ColorFilter.hueRanges
              ? _dataController.hueRanges.toList()
              : <ColourloversRequestHueRange>[];
      final hex =
          _dataController.colorFilter == ColorFilter.hex
              ? [_dataController.hex]
              : <String>[];
      final keywords = _dataController.paletteName;

      switch (_dataController.showCriteria) {
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

  void showPaletteFilters(BuildContext context) {
    openScreen<void>(
      context,
      const PaletteFiltersViewCreator(),
      fullscreenDialog: true,
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

  Future<void> showRandomPalette(BuildContext context) async {
    final palette = await _client.getRandomPalette();
    if (palette == null) return;
    _showPaletteDetails(context, palette);
  }

  void _showPaletteDetails(BuildContext context, ColourloversPalette palette) {
    openScreen<void>(context, PaletteDetailsViewCreator(palette: palette));
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
        paletteName: _dataController.paletteName,
        userName: _dataController.userName,
        itemsList: ItemListViewState(
          isLoading: _pagination.isLoading,
          items:
              _pagination.items
                  .map(PaletteTileViewState.fromColourloverPalette)
                  .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
