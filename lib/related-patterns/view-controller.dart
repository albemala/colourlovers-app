import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPatternsViewController
    extends Cubit<ItemsListViewState<PatternTileViewState>> {
  factory RelatedPatternsViewController.fromContext(
    BuildContext context, {
    required List<String> hex,
  }) {
    return RelatedPatternsViewController(
      hex,
      ColourloversApiClient(),
    );
  }

  final List<String> _hex;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  RelatedPatternsViewController(
    this._hex,
    this._client,
  ) : super(
          ItemsListViewState.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return fetchRelatedPatterns(_client, numResults, offset, _hex);
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
    openScreen(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void _updateState() {
    emit(
      ItemsListViewState(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PatternTileViewState.fromColourloverPattern)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}
