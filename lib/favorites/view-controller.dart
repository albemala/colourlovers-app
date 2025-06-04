import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesViewController extends Cubit<FavoritesViewState> {
  final FavoritesDataController _favoritesDataController;
  StreamSubscription<FavoritesDataState>? _favoritesDataControllerSubscription;

  factory FavoritesViewController.fromContext(BuildContext context) {
    return FavoritesViewController(context.read<FavoritesDataController>());
  }

  FavoritesViewController(this._favoritesDataController)
    : super(defaultFavoritesViewState) {
    _favoritesDataControllerSubscription = _favoritesDataController.stream
        .listen((_) {
          _updateItems();
        });
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _updateItems();
  }

  @override
  Future<void> close() {
    _favoritesDataControllerSubscription?.cancel();
    return super.close();
  }

  void _updateItems() {
    final items =
        _favoritesDataController.favorites
            .map(_convertFavoriteItemToTileViewState)
            .toIList();
    emit(state.copyWith(items: items));
  }

  void showColorDetails(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final favoriteItem = _favoritesDataController.findFavorite(
      tileViewState.id,
      FavoriteItemType.color,
    );
    if (favoriteItem == null) return;
    final color = ColourloversColor.fromJson(favoriteItem.data.unlock);
    openScreen<void>(context, ColorDetailsViewCreator(color: color));
  }

  void showPaletteDetails(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final favoriteItem = _favoritesDataController.findFavorite(
      tileViewState.id,
      FavoriteItemType.palette,
    );
    if (favoriteItem == null) return;
    final palette = ColourloversPalette.fromJson(favoriteItem.data.unlock);
    openScreen<void>(context, PaletteDetailsViewCreator(palette: palette));
  }

  void showPatternDetails(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final favoriteItem = _favoritesDataController.findFavorite(
      tileViewState.id,
      FavoriteItemType.pattern,
    );
    if (favoriteItem == null) return;
    final pattern = ColourloversPattern.fromJson(favoriteItem.data.unlock);
    openScreen<void>(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void showUserDetails(BuildContext context, UserTileViewState tileViewState) {
    final favoriteItem = _favoritesDataController.findFavorite(
      tileViewState.id,
      FavoriteItemType.user,
    );
    if (favoriteItem == null) return;
    final user = ColourloversLover.fromJson(favoriteItem.data.unlock);
    openScreen<void>(context, UserDetailsViewCreator(user: user));
  }

  Equatable _convertFavoriteItemToTileViewState(FavoriteItem item) {
    return switch (item.type) {
      FavoriteItemType.color => ColorTileViewState.fromColourloverColor(
        ColourloversColor.fromJson(item.data.unlock),
      ),
      FavoriteItemType.palette => PaletteTileViewState.fromColourloverPalette(
        ColourloversPalette.fromJson(item.data.unlock),
      ),
      FavoriteItemType.pattern => PatternTileViewState.fromColourloverPattern(
        ColourloversPattern.fromJson(item.data.unlock),
      ),
      FavoriteItemType.user => UserTileViewState.fromColourloverUser(
        ColourloversLover.fromJson(item.data.unlock),
      ),
      _ => throw Exception('Unknown favorite item type: ${item.type}'),
    };
  }
}
