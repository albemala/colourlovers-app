import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related/patterns/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPatternsViewController extends Cubit<RelatedPatternsViewState> {
  final List<String> _hex;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  factory RelatedPatternsViewController.fromContext(
    BuildContext context, {
    required List<String> hex,
  }) {
    return RelatedPatternsViewController(hex, ColourloversApiClient());
  }

  RelatedPatternsViewController(this._hex, this._client)
    : super(defaultRelatedPatternsViewState) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return fetchRelatedPatterns(_client, numResults, offset, _hex);
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

  void showPatternDetails(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final pattern = _pagination.items[index];
    openScreen<void>(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void _updateState() {
    emit(
      state.copyWith(
        itemsList: ItemListViewState(
          isLoading: _pagination.isLoading,
          items:
              _pagination
                  .items //
                  .map(PatternTileViewState.fromColourloverPattern)
                  .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
