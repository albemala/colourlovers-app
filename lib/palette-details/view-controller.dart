import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/palette-details/view-state.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteDetailsViewController extends Cubit<PaletteDetailsViewState> {
  factory PaletteDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversPalette palette,
  }) {
    return PaletteDetailsViewController(
      palette,
      ColourloversApiClient(),
    );
  }

  final ColourloversPalette _palette;
  final ColourloversApiClient _client;
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  PaletteDetailsViewController(
    this._palette,
    this._client,
  ) : super(defaultPaletteDetailsViewState) {
    _init();
  }

  Future<void> _init() async {
    _user = _palette.userName != null
        ? await fetchUser(_client, _palette.userName!)
        : null;
    _colors = _palette.colors != null
        ? await fetchColors(_client, _palette.colors!)
        : <ColourloversColor>[];
    _relatedPalettes = _palette.colors != null
        ? await fetchRelatedPalettesPreview(_client, _palette.colors!)
        : <ColourloversPalette>[];
    _relatedPatterns = _palette.colors != null
        ? await fetchRelatedPatternsPreview(_client, _palette.colors!)
        : <ColourloversPattern>[];

    _updateState();
  }

  void _updateState() {
    emit(
      PaletteDetailsViewState(
        isLoading: false,
        id: (_palette.id ?? 0).toString(),
        title: _palette.title ?? '',
        colors: _palette.colors?.toIList() ?? const IList.empty(),
        colorWidths: _palette.colorWidths?.toIList() ?? const IList.empty(),
        colorViewStates: _colors //
            .map(ColorTileViewState.fromColourloverColor)
            .toIList(),
        numViews: (_palette.numViews ?? 0).toString(),
        numVotes: (_palette.numVotes ?? 0).toString(),
        rank: (_palette.rank ?? 0).toString(),
        user: _user != null //
            ? UserTileViewState.fromColourloverUser(_user!)
            : defaultUserTileViewState,
        relatedPalettes: _relatedPalettes //
            .map(PaletteTileViewState.fromColourloverPalette)
            .toIList(),
        relatedPatterns: _relatedPatterns //
            .map(PatternTileViewState.fromColourloverPattern)
            .toIList(),
      ),
    );
  }

  void showSharePaletteView(BuildContext context) {
    openScreen(context, SharePaletteViewCreator(palette: _palette));
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.colorViewStates.indexOf(tileViewState);
    openScreen(
      context,
      ColorDetailsViewCreator(color: _colors[index]),
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

  void showRelatedPalettesView(BuildContext context) {
    if (_palette.colors == null) return;
    openScreen(
      context,
      RelatedPalettesViewCreator(hex: _palette.colors!),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    if (_palette.colors == null) return;
    openScreen(
      context,
      RelatedPatternsViewCreator(hex: _palette.colors!),
    );
  }
}
