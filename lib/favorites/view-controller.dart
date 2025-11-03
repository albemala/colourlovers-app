import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/filters/favorites/data-controller.dart';
import 'package:colourlovers_app/filters/favorites/data-state.dart';
import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/filters/favorites/view.dart';
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
  final FavoritesFiltersDataController _favoritesFiltersDataController;
  StreamSubscription<FavoritesDataState>? _favoritesDataControllerSubscription;
  StreamSubscription<FavoritesFiltersDataState>?
  _favoritesFiltersDataControllerSubscription;

  factory FavoritesViewController.fromContext(BuildContext context) {
    return FavoritesViewController(
      context.read<FavoritesDataController>(),
      context.read<FavoritesFiltersDataController>(),
    );
  }

  FavoritesViewController(
    this._favoritesDataController,
    this._favoritesFiltersDataController,
  ) : super(defaultFavoritesViewState) {
    _favoritesDataControllerSubscription = _favoritesDataController.stream
        .listen((_) {
          _updateItems();
        });
    _favoritesFiltersDataControllerSubscription =
        _favoritesFiltersDataController.stream.listen((_) {
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
    _favoritesFiltersDataControllerSubscription?.cancel();
    return super.close();
  }

  void _updateItems() {
    final currentFilters = _favoritesFiltersDataController.state;
    var filteredFavorites = _favoritesDataController.favorites.toList();

    // Apply type filter
    if (currentFilters.typeFilter != FavoriteItemTypeFilter.all) {
      filteredFavorites = filteredFavorites.where((item) {
        return item.type.name == currentFilters.typeFilter.name;
      }).toList();
    }

    // Apply sorting
    if (currentFilters.sortBy == FavoriteSortBy.timeAdded) {
      if (currentFilters.sortOrder == FavoriteSortOrder.ascending) {
        filteredFavorites.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
      } else {
        filteredFavorites.sort((a, b) => a.timeAdded.compareTo(b.timeAdded));
      }
    }

    final items = filteredFavorites
        .map(_convertFavoriteItemToTileViewState)
        .toIList();
    emit(
      state.copyWith(
        items: items,
        typeFilter: currentFilters.typeFilter,
        sortBy: currentFilters.sortBy,
        sortOrder: currentFilters.sortOrder,
      ),
    );
  }

  void showFavoritesFilters(BuildContext context) {
    openScreen<void>(context, const FavoritesFiltersViewCreator());
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
