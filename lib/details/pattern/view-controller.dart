import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view-state.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related/palettes/view.dart';
import 'package:colourlovers_app/related/patterns/view.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/share/pattern/view.dart';
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

class PatternDetailsViewController extends Cubit<PatternDetailsViewState> {
  final ColourloversPattern _pattern;
  final ColourloversApiClient _client;
  final FavoritesDataController _favoritesDataController;
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  StreamSubscription<FavoritesDataState>? _favoritesDataControllerSubscription;

  factory PatternDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversPattern pattern,
  }) {
    return PatternDetailsViewController(
      pattern,
      ColourloversApiClient(),
      context.read<FavoritesDataController>(),
    );
  }

  PatternDetailsViewController(
    this._pattern,
    this._client,
    this._favoritesDataController,
  ) : super(defaultPatternDetailsViewState) {
    _favoritesDataControllerSubscription = _favoritesDataController.stream
        .listen((_) {
          _updateIsFavoritedState();
        });
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _init();
  }

  @override
  Future<void> close() {
    _favoritesDataControllerSubscription?.cancel();
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
    final userName = _pattern.userName;
    if (userName == null) return;
    _user = await fetchUser(_client, userName);
  }

  Future<void> _initColors() async {
    final colors = _pattern.colors;
    if (colors == null) return;
    _colors = await fetchColors(_client, colors);
  }

  Future<void> _initRelatedPalettes() async {
    final colors = _pattern.colors;
    if (colors == null) return;
    _relatedPalettes = await fetchRelatedPalettesPreview(_client, colors);
  }

  Future<void> _initRelatedPatterns() async {
    final colors = _pattern.colors;
    if (colors == null) return;
    _relatedPatterns = await fetchRelatedPatternsPreview(_client, colors);
  }

  void _updateState() {
    emit(
      state
          .copyWith(isLoading: false)
          .copyWithColourloversPattern(pattern: _pattern)
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

  void showSharePatternView(BuildContext context) {
    openScreen<void>(context, SharePatternViewCreator(pattern: _pattern));
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.colorViewStates.indexOf(tileViewState);
    final color = _colors[index];
    openScreen<void>(context, ColorDetailsViewCreator(color: color));
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.relatedPalettes.indexOf(tileViewState);
    final palette = _relatedPalettes[index];
    openScreen<void>(context, PaletteDetailsViewCreator(palette: palette));
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.relatedPatterns.indexOf(tileViewState);
    final pattern = _relatedPatterns[index];
    openScreen<void>(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void showUserDetailsView(BuildContext context) {
    final user = _user;
    if (user == null) return;
    openScreen<void>(context, UserDetailsViewCreator(user: user));
  }

  void showRelatedPalettesView(BuildContext context) {
    final colors = _pattern.colors;
    if (colors == null) return;
    openScreen<void>(context, RelatedPalettesViewCreator(hex: colors));
  }

  void showRelatedPatternsView(BuildContext context) {
    final colors = _pattern.colors;
    if (colors == null) return;
    openScreen<void>(context, RelatedPatternsViewCreator(hex: colors));
  }

  String get patternId => _pattern.id?.toString() ?? '';
  IMap<String, dynamic> get patternData => _pattern.toJson().toIMap();

  void toggleFavorite() {
    _favoritesDataController.toggleFavorite(
      FavoriteItemType.pattern,
      patternId,
      patternData,
    );
  }

  void _updateIsFavoritedState() {
    emit(
      state.copyWith(
        isFavorited: _favoritesDataController.isFavorite(
          FavoriteItemType.pattern,
          patternId,
        ),
      ),
    );
  }
}
