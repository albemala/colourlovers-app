import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related/colors/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedColorsViewController extends Cubit<RelatedColorsViewState> {
  final Hsv _hsv;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  factory RelatedColorsViewController.fromContext(
    BuildContext _, {
    required Hsv hsv,
  }) {
    return RelatedColorsViewController(hsv, ColourloversApiClient());
  }

  RelatedColorsViewController(this._hsv, this._client)
    : super(RelatedColorsViewState.initial()) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return fetchRelatedColors(_client, numResults, offset, _hsv);
    });
    _pagination.addListener(updateViewState);
    unawaited(_pagination.load());

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
  }

  @override
  Future<void> close() {
    _pagination.removeListener(updateViewState);
    return super.close();
  }

  Future<void> loadMore() async {
    await _pagination.loadMore();
  }

  void showColorDetails(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final color = _pagination.items[index];
    unawaited(openScreen<void>(context, ColorDetailsViewCreator(color: color)));
  }

  void updateViewState() {
    emit(
      state.copyWith(
        itemsList: ItemListViewState(
          isLoading: _pagination.isLoading,
          items: _pagination
              .items //
              .map(ColorTileViewState.fromColourloverColor)
              .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
