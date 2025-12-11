import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/color/view-state.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related/colors/view.dart';
import 'package:colourlovers_app/related/palettes/view.dart';
import 'package:colourlovers_app/related/patterns/view.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/share/color/view.dart';
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

class ColorDetailsViewController extends Cubit<ColorDetailsViewState> {
  final ColourloversColor _color;
  final ColourloversApiClient _client;
  final FavoritesDataController _favoritesDataController;
  ColourloversLover? _user;
  List<ColourloversColor> _relatedColors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  StreamSubscription<FavoritesDataState>? _favoritesDataControllerSubscription;

  factory ColorDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversColor color,
  }) {
    return ColorDetailsViewController(
      color,
      ColourloversApiClient(),
      context.read<FavoritesDataController>(),
    );
  }

  ColorDetailsViewController(
    this._color,
    this._client,
    this._favoritesDataController,
  ) : super(ColorDetailsViewState.initial()) {
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
    await _initRelatedColors();
    await _initRelatedPalettes();
    await _initRelatedPatterns();
    _updateState();
    _updateIsFavoritedState();
  }

  Future<void> _initUser() async {
    final userName = _color.userName;
    if (userName == null) return;
    _user = await fetchUser(_client, userName);
  }

  Future<void> _initRelatedColors() async {
    final hsv = _color.hsv;
    if (hsv == null) return;
    _relatedColors = await fetchRelatedColorsPreview(_client, hsv);
  }

  Future<void> _initRelatedPalettes() async {
    final hex = _color.hex;
    if (hex == null) return;
    _relatedPalettes = await fetchRelatedPalettesPreview(_client, [hex]);
  }

  Future<void> _initRelatedPatterns() async {
    final hex = _color.hex;
    if (hex == null) return;
    _relatedPatterns = await fetchRelatedPatternsPreview(_client, [hex]);
  }

  void _updateState() {
    emit(
      state
          .copyWith(isLoading: false)
          .copyWithColourloversColor(color: _color)
          .copyWith(
            user: UserTileViewState.fromColourloverUser(_user),
            relatedColors: mapToTileViewState(
              _relatedColors,
              ColorTileViewState.fromColourloverColor,
            ),
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

  void showShareColorView(BuildContext context) {
    unawaited(openScreen<void>(context, ShareColorViewCreator(color: _color)));
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.relatedColors.indexOf(tileViewState);
    final color = _relatedColors[index];
    unawaited(openScreen<void>(context, ColorDetailsViewCreator(color: color)));
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

  void showRelatedColorsView(BuildContext context) {
    final hsv = _color.hsv;
    if (hsv == null) return;
    unawaited(openScreen<void>(context, RelatedColorsViewCreator(hsv: hsv)));
  }

  void showRelatedPalettesView(BuildContext context) {
    final hex = _color.hex;
    if (hex == null) return;
    unawaited(
      openScreen<void>(context, RelatedPalettesViewCreator(hex: [hex])),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    final hex = _color.hex;
    if (hex == null) return;
    unawaited(
      openScreen<void>(context, RelatedPatternsViewCreator(hex: [hex])),
    );
  }

  String get colorId => _color.id?.toString() ?? '';
  IMap<String, dynamic> get colorData => _color.toJson().toIMap();

  void toggleFavorite() {
    _favoritesDataController.toggleFavorite(
      FavoriteItemType.color,
      colorId,
      colorData,
    );
  }

  void _updateIsFavoritedState() {
    emit(
      state.copyWith(
        isFavorited: _favoritesDataController.isFavorite(
          FavoriteItemType.color,
          colorId,
        ),
      ),
    );
  }
}
