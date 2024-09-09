import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPalettesViewController
    extends Cubit<ItemsListViewState<PaletteTileViewState>> {
  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPalette> _pagination;

  factory UserPalettesViewController.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserPalettesViewController(
      userName,
      ColourloversApiClient(),
    );
  }

  UserPalettesViewController(
    this._userName,
    this._client,
  ) : super(defaultPalettesListViewState) {
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      return fetchUserPalettes(_client, numResults, offset, _userName);
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
            .toIList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}
