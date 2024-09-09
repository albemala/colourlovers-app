import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserColorsViewController
    extends Cubit<ItemsListViewState<ColorTileViewState>> {
  factory UserColorsViewController.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserColorsViewController(
      userName,
      ColourloversApiClient(),
    );
  }

  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  UserColorsViewController(
    this._userName,
    this._client,
  ) : super(defaultColorsListViewState) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return fetchUserColors(_client, numResults, offset, _userName);
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
