import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedColorsViewController
    extends Cubit<ItemsListViewState<ColorTileViewState>> {
  factory RelatedColorsViewController.fromContext(
    BuildContext context, {
    required Hsv hsv,
  }) {
    return RelatedColorsViewController(
      hsv,
      ColourloversApiClient(),
    );
  }

  final Hsv _hsv;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  RelatedColorsViewController(
    this._hsv,
    this._client,
  ) : super(defaultColorsListViewState) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return fetchRelatedColors(_client, numResults, offset, _hsv);
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

  void showColorDetails(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.items.indexOf(tileViewState);
    final color = _pagination.items[index];
    openScreen(context, ColorDetailsViewCreator(color: color));
  }

  void _updateState() {
    emit(
      ItemsListViewState(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(ColorTileViewState.fromColourloverColor)
            .toIList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}
