import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPalettesViewController
    extends Cubit<ItemsListViewState<PaletteTileViewState>> {
  factory RelatedPalettesViewController.fromContext(
    BuildContext context, {
    required List<String> hex,
  }) {
    return RelatedPalettesViewController(
      hex,
      ColourloversApiClient(),
    );
  }

  final List<String> _hex;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPalette> _pagination;

  RelatedPalettesViewController(
    this._hex,
    this._client,
  ) : super(
          ItemsListViewState.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      return fetchRelatedPalettes(_client, numResults, offset, _hex);
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

  void showPaletteDetails(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.items.indexOf(tileViewState);
    final palette = _pagination.items[index];
    openScreen(context, PaletteDetailsViewCreator(palette: palette));
  }

  void _updateState() {
    emit(
      ItemsListViewState(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PaletteTileViewState.fromColourloverPalette)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}
