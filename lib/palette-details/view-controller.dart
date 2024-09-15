import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/formatters.dart';
import 'package:colourlovers_app/palette-details/view-state.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
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
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  factory PaletteDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversPalette palette,
  }) {
    return PaletteDetailsViewController(
      palette,
      ColourloversApiClient(),
    );
  }

  PaletteDetailsViewController(
    this._palette,
    this._client,
  ) : super(defaultPaletteDetailsViewState) {
    emit(state.copyWith(
        backgroundBlobs:
            generateBackgroundBlobs(getRandomPalette()).toIList()));
    _init();
  }

  Future<void> _init() async {
    await _initUser();
    await _initColors();
    await _initRelatedPalettes();
    await _initRelatedPatterns();
    _updateState();
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
      state.copyWith(
        isLoading: false,
        id: _palette.id.formatted(),
        title: _palette.title ?? '',
        colors: _palette.colors?.toIList() ?? const IList.empty(),
        colorWidths: _palette.colorWidths?.toIList() ?? const IList.empty(),
        colorViewStates: mapToTileViewState(
          _colors,
          ColorTileViewState.fromColourloverColor,
        ),
        numViews: _palette.numViews.formatted(),
        numVotes: _palette.numVotes.formatted(),
        rank: _palette.rank.formatted(),
        user: _user != null
            ? UserTileViewState.fromColourloverUser(_user!)
            : defaultUserTileViewState,
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

  void showRelatedPalettesView(BuildContext context) {
    final colors = _palette.colors;
    if (colors == null) return;
    openScreen(
      context,
      RelatedPalettesViewCreator(hex: colors),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    final colors = _palette.colors;
    if (colors == null) return;
    openScreen(
      context,
      RelatedPatternsViewCreator(hex: colors),
    );
  }
}
