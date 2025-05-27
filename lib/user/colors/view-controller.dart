import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/user/colors/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserColorsViewController extends Cubit<UserColorsViewState> {
  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  factory UserColorsViewController.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserColorsViewController(userName, ColourloversApiClient());
  }

  UserColorsViewController(this._userName, this._client)
    : super(defaultUserColorsViewState) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return fetchUserColors(_client, numResults, offset, _userName);
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

  void showColorDetails(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final color = _pagination.items[index];
    openScreen<void>(context, ColorDetailsViewCreator(color: color));
  }

  void _updateState() {
    emit(
      state.copyWith(
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items:
              _pagination
                  .items //
                  .map(ColorTileViewState.fromColourloverColor)
                  .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
