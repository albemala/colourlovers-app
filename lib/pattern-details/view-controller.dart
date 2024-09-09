import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view-state.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-pattern/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternDetailsViewController extends Cubit<PatternDetailsViewState> {
  factory PatternDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversPattern pattern,
  }) {
    return PatternDetailsViewController(
      pattern,
      ColourloversApiClient(),
    );
  }

  final ColourloversPattern _pattern;
  final ColourloversApiClient _client;
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  PatternDetailsViewController(
    this._pattern,
    this._client,
  ) : super(defaultPatternDetailsViewState) {
    _init();
  }

  Future<void> _init() async {
    _user = _pattern.userName != null
        ? await fetchUser(_client, _pattern.userName!)
        : null;
    _colors = _pattern.colors != null
        ? await fetchColors(_client, _pattern.colors!)
        : <ColourloversColor>[];
    _relatedPalettes = _pattern.colors != null
        ? await fetchRelatedPalettesPreview(_client, _pattern.colors!)
        : <ColourloversPalette>[];
    _relatedPatterns = _pattern.colors != null
        ? await fetchRelatedPatternsPreview(_client, _pattern.colors!)
        : <ColourloversPattern>[];

    _updateState();
  }

  void _updateState() {
    emit(
      PatternDetailsViewState(
        isLoading: false,
        id: (_pattern.id ?? 0).toString(),
        title: _pattern.title ?? '',
        colors: _pattern.colors?.toIList() ?? const IList.empty(),
        colorViewStates: _colors //
            .map(ColorTileViewState.fromColourloverColor)
            .toIList(),
        imageUrl: _pattern.imageUrl ?? '',
        numViews: (_pattern.numViews ?? 0).toString(),
        numVotes: (_pattern.numVotes ?? 0).toString(),
        rank: (_pattern.rank ?? 0).toString(),
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

  void showSharePatternView(BuildContext context) {
    openScreen(context, SharePatternViewCreator(pattern: _pattern));
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
    if (_pattern.colors == null) return;
    openScreen(
      context,
      RelatedPalettesViewCreator(hex: _pattern.colors!),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    if (_pattern.colors == null) return;
    openScreen(
      context,
      RelatedPatternsViewCreator(hex: _pattern.colors!),
    );
  }
}
