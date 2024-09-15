import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/user-patterns/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPatternsViewController extends Cubit<UserPatternsViewState> {
  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  factory UserPatternsViewController.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserPatternsViewController(
      userName,
      ColourloversApiClient(),
    );
  }

  UserPatternsViewController(
    this._userName,
    this._client,
  ) : super(defaultUserPatternsViewState) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return fetchUserPatterns(_client, numResults, offset, _userName);
    });
    _pagination.addListener(_updateState);
    _pagination.load();

    emit(state.copyWith(
        backgroundBlobs:
            generateBackgroundBlobs(getRandomPalette()).toIList()));
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
    openScreen(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void _updateState() {
    emit(
      state.copyWith(
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items: _pagination.items //
              .map(PatternTileViewState.fromColourloverPattern)
              .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
