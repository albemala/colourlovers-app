import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternsViewController
    extends Cubit<ItemsListViewState<PatternTileViewState>> {
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  factory PatternsViewController.fromContext(BuildContext context) {
    return PatternsViewController(
      ColourloversApiClient(),
    );
  }

  PatternsViewController(
    this._client,
  ) : super(defaultPatternsListViewState) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return _client.getPatterns(
        numResults: numResults,
        resultOffset: offset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ColourloversRequestSortBy.DESC,
      );
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

  void showPatternDetails(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.items.indexOf(tileViewState);
    final pattern = _pagination.items[index];
    _showPatternDetailsView(context, pattern);
  }

  Future<void> showRandomPattern(
    BuildContext context,
  ) async {
    final pattern = await _client.getRandomPattern();
    if (pattern == null) return;
    _showPatternDetailsView(context, pattern);
  }

  void _showPatternDetailsView(
    BuildContext context,
    ColourloversPattern pattern,
  ) {
    openScreen(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void _updateState() {
    emit(
      ItemsListViewState(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PatternTileViewState.fromColourloverPattern)
            .toIList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}
