import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view-state.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-colors/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-color/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
    _user = _color.userName != null
        ? await fetchUser(_client, _color.userName!)
        : null;
    _relatedColors = _color.hsv != null
        ? await fetchRelatedColorsPreview(_client, _color.hsv!)
        : <ColourloversColor>[];
    _relatedPalettes = _color.hex != null
        ? await fetchRelatedPalettesPreview(_client, [_color.hex!])
        : <ColourloversPalette>[];
    _relatedPatterns = _color.hex != null
        ? await fetchRelatedPatternsPreview(_client, [_color.hex!])
        : <ColourloversPattern>[];

    _updateState();
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
        numViews: (_color.numViews ?? 0).toString(),
        numVotes: (_color.numVotes ?? 0).toString(),
        rank: (_color.rank ?? 0).toString(),
        user: _user != null
            ? UserTileViewState.fromColourloverUser(_user!)
            : defaultUserTileViewState,
        relatedColors: _relatedColors //
            .map(ColorTileViewState.fromColourloverColor)
            .toIList(),
        relatedPalettes: _relatedPalettes //
            .map(PaletteTileViewState.fromColourloverPalette)
            .toIList(),
        relatedPatterns: _relatedPatterns //
            .map(PatternTileViewState.fromColourloverPattern)
            .toIList(),
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
    openScreen(
      context,
      ColorDetailsViewCreator(color: _relatedColors[index]),
    );
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.relatedPalettes.indexOf(tileViewState);
    openScreen(
      context,
      PaletteDetailsViewCreator(palette: _relatedPalettes[index]),
    );
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.relatedPatterns.indexOf(tileViewState);
    openScreen(
      context,
      PatternDetailsViewCreator(pattern: _relatedPatterns[index]),
    );
  }

  void showUserDetailsView(BuildContext context) {
    if (_user == null) return;
    openScreen(
      context,
      UserDetailsViewCreator(user: _user!),
    );
  }

  void showRelatedColorsView(BuildContext context) {
    if (_color.hsv == null) return;
    openScreen(
      context,
      RelatedColorsViewCreator(hsv: _color.hsv!),
    );
  }

  void showRelatedPalettesView(BuildContext context) {
    if (_color.hex == null) return;
    openScreen(
      context,
      RelatedPalettesViewCreator(hex: [_color.hex!]),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    if (_color.hex == null) return;
    openScreen(
      context,
      RelatedPatternsViewCreator(hex: [_color.hex!]),
    );
  }
}
