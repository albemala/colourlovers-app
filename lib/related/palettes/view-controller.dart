import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related/palettes/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPalettesViewController extends Cubit<RelatedPalettesViewState> {
  final List<String> _hex;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPalette> _pagination;

  factory RelatedPalettesViewController.fromContext(
    BuildContext context, {
    required List<String> hex,
  }) {
    return RelatedPalettesViewController(hex, ColourloversApiClient());
  }

  RelatedPalettesViewController(this._hex, this._client)
    : super(defaultRelatedPalettesViewState) {
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      return fetchRelatedPalettes(_client, numResults, offset, _hex);
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
    _pagination.removeListener(_updateState);
    return super.close();
  }

  Future<void> loadMore() async {
    await _pagination.loadMore();
  }

  void showPaletteDetails(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final palette = _pagination.items[index];
    openScreen<void>(context, PaletteDetailsViewCreator(palette: palette));
  }

  void _updateState() {
    emit(
      state.copyWith(
        itemsList: ItemListViewState(
          isLoading: _pagination.isLoading,
          items:
              _pagination
                  .items //
                  .map(PaletteTileViewState.fromColourloverPalette)
                  .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
