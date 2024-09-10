import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view-state.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/formatters.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-colors/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-color/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorDetailsViewController extends Cubit<ColorDetailsViewState> {
  final ColourloversColor _color;
  final ColourloversApiClient _client;
  ColourloversLover? _user;
  List<ColourloversColor> _relatedColors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  factory ColorDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversColor color,
  }) {
    return ColorDetailsViewController(
      color,
      ColourloversApiClient(),
    );
  }

  ColorDetailsViewController(
    this._color,
    this._client,
  ) : super(defaultColorDetailsViewState) {
    _init();
  }

  Future<void> _init() async {
    await _initUser();
    await _initRelatedColors();
    await _initRelatedPalettes();
    await _initRelatedPatterns();
    _updateState();
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
      ColorDetailsViewState(
        isLoading: false,
        title: _color.title ?? '',
        hex: _color.hex ?? '',
        rgb: _color.rgb != null
            ? ColorRgbViewState.fromColourloverRgb(_color.rgb!)
            : defaultColorRgbViewState,
        hsv: _color.hsv != null
            ? ColorHsvViewState.fromColourloverHsv(_color.hsv!)
            : defaultColorHsvViewState,
        numViews: _color.numViews.formatted(),
        numVotes: _color.numVotes.formatted(),
        rank: _color.rank.formatted(),
        user: _user != null
            ? UserTileViewState.fromColourloverUser(_user!)
            : defaultUserTileViewState,
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
    openScreen(context, ShareColorViewCreator(color: _color));
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.relatedColors.indexOf(tileViewState);
    final color = _relatedColors[index];
    openScreen(
      context,
      ColorDetailsViewCreator(color: color),
    );
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.relatedPalettes.indexOf(tileViewState);
    final palette = _relatedPalettes[index];
    openScreen(
      context,
      PaletteDetailsViewCreator(palette: palette),
    );
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.relatedPatterns.indexOf(tileViewState);
    final pattern = _relatedPatterns[index];
    openScreen(
      context,
      PatternDetailsViewCreator(pattern: pattern),
    );
  }

  void showUserDetailsView(BuildContext context) {
    final user = _user;
    if (user == null) return;
    openScreen(
      context,
      UserDetailsViewCreator(user: user),
    );
  }

  void showRelatedColorsView(BuildContext context) {
    final hsv = _color.hsv;
    if (hsv == null) return;
    openScreen(
      context,
      RelatedColorsViewCreator(hsv: hsv),
    );
  }

  void showRelatedPalettesView(BuildContext context) {
    final hex = _color.hex;
    if (hex == null) return;
    openScreen(
      context,
      RelatedPalettesViewCreator(hex: [hex]),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    final hex = _color.hex;
    if (hex == null) return;
    openScreen(
      context,
      RelatedPatternsViewCreator(hex: [hex]),
    );
  }
}
