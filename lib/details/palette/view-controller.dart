import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view-state.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related/palettes/view.dart';
import 'package:colourlovers_app/related/patterns/view.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/share/palette/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteDetailsViewController extends Cubit<PaletteDetailsViewState> {
  final ColourloversPalette _palette;
  final ColourloversApiClient _client;
  final FavoritesDataController _favoritesDataController;
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  StreamSubscription<FavoritesDataState>? _favoritesDataControllerSubscription;

  factory PaletteDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversPalette palette,
  }) {
    return PaletteDetailsViewController(
      palette,
      ColourloversApiClient(),
      context.read<FavoritesDataController>(),
    );
  }

  PaletteDetailsViewController(
    this._palette,
    this._client,
    this._favoritesDataController,
  ) : super(PaletteDetailsViewState.initial()) {
    _favoritesDataControllerSubscription = _favoritesDataController.stream
        .listen((_) {
          _updateIsFavoritedState();
        });
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    unawaited(_init());
  }

  @override
  Future<void> close() async {
    await _favoritesDataControllerSubscription?.cancel();
    return super.close();
  }

  Future<void> _init() async {
    await _initUser();
    await _initColors();
    await _initRelatedPalettes();
    await _initRelatedPatterns();
    _updateState();
    _updateIsFavoritedState();
  }

  Future<void> _initUser() async {
    final userName = _palette.userName;
    if (userName == null) return;
    _user = await fetchUser(_client, userName);
  }

  Future<void> _initColors() async {
    final colors = _palette.colors;
    if (colors == null) return;
    _colors = await fetchColors(_client, colors);
  }

  Future<void> _initRelatedPalettes() async {
    final colors = _palette.colors;
    if (colors == null) return;
    _relatedPalettes = await fetchRelatedPalettesPreview(_client, colors);
  }

  Future<void> _initRelatedPatterns() async {
    final colors = _palette.colors;
    if (colors == null) return;
    _relatedPatterns = await fetchRelatedPatternsPreview(_client, colors);
  }

  void _updateState() {
    emit(
      state
          .copyWith(isLoading: false)
          .copyWithColourloversPalette(palette: _palette)
          .copyWith(
            colorViewStates: mapToTileViewState(
              _colors,
              ColorTileViewState.fromColourloverColor,
            ),
            user: UserTileViewState.fromColourloverUser(_user),
            relatedPalettes: mapToTileViewState(
              _relatedPalettes,
              PaletteTileViewState.fromColourloverPalette,
            ),
            relatedPatterns: mapToTileViewState(
              _relatedPatterns,
              PatternTileViewState.fromColourloverPattern,
            ),
          ),
    );
  }

  void showSharePaletteView(BuildContext context) {
    unawaited(
      openScreen<void>(context, SharePaletteViewCreator(palette: _palette)),
    );
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.colorViewStates.indexOf(tileViewState);
    unawaited(
      openScreen<void>(context, ColorDetailsViewCreator(color: _colors[index])),
    );
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.relatedPalettes.indexOf(tileViewState);
    final palette = _relatedPalettes[index];
    unawaited(
      openScreen<void>(context, PaletteDetailsViewCreator(palette: palette)),
    );
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.relatedPatterns.indexOf(tileViewState);
    final pattern = _relatedPatterns[index];
    unawaited(
      openScreen<void>(context, PatternDetailsViewCreator(pattern: pattern)),
    );
  }

  void showUserDetailsView(BuildContext context) {
    final user = _user;
    if (user == null) return;
    unawaited(openScreen<void>(context, UserDetailsViewCreator(user: user)));
  }

  void showRelatedPalettesView(BuildContext context) {
    final colors = _palette.colors;
    if (colors == null) return;
    unawaited(
      openScreen<void>(context, RelatedPalettesViewCreator(hex: colors)),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    final colors = _palette.colors;
    if (colors == null) return;
    unawaited(
      openScreen<void>(context, RelatedPatternsViewCreator(hex: colors)),
    );
  }

  String get paletteId => _palette.id?.toString() ?? '';
  IMap<String, dynamic> get paletteData => _palette.toJson().toIMap();

  void toggleFavorite() {
    _favoritesDataController.toggleFavorite(
      FavoriteItemType.palette,
      paletteId,
      paletteData,
    );
  }

  void _updateIsFavoritedState() {
    emit(
      state.copyWith(
        isFavorited: _favoritesDataController.isFavorite(
          FavoriteItemType.palette,
          paletteId,
        ),
      ),
    );
  }
}
