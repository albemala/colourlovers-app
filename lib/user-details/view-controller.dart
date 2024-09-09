import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/user-colors/view.dart';
import 'package:colourlovers_app/user-details/view-state.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/user-palettes/view.dart';
import 'package:colourlovers_app/user-patterns/view.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsViewController extends Cubit<UserDetailsViewState> {
  factory UserDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversLover user,
  }) {
    return UserDetailsViewController(
      user,
      ColourloversApiClient(),
    );
  }

  final ColourloversLover _user;
  final ColourloversApiClient _client;
  List<ColourloversColor> _userColors = [];
  List<ColourloversPalette> _userPalettes = [];
  List<ColourloversPattern> _userPatterns = [];

  UserDetailsViewController(
    this._user,
    this._client,
  ) : super(
          UserDetailsViewState.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final userName = _user.userName ?? '';
    _userColors = await fetchUserColorsPreview(_client, userName);
    _userPalettes = await fetchUserPalettesPreview(_client, userName);
    _userPatterns = await fetchUserPatternsPreview(_client, userName);

    _updateState();
  }

  void _updateState() {
    emit(
      UserDetailsViewState(
        isLoading: false,
        userName: _user.userName ?? '',
        numColors: (_user.numColors ?? 0).toString(),
        numPalettes: (_user.numPalettes ?? 0).toString(),
        numPatterns: (_user.numPatterns ?? 0).toString(),
        rating: (_user.rating ?? 0).toString(),
        numLovers: (_user.numLovers ?? 0).toString(),
        location: _user.location ?? '',
        dateRegistered: _formatDate(_user.dateRegistered),
        dateLastActive: _formatDate(_user.dateLastActive),
        userColors: _userColors //
            .map(ColorTileViewState.fromColourloverColor)
            .toList(),
        userPalettes: _userPalettes //
            .map(PaletteTileViewState.fromColourloverPalette)
            .toList(),
        userPatterns: _userPatterns //
            .map(PatternTileViewState.fromColourloverPattern)
            .toList(),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.userColors.indexOf(tileViewState);
    openScreen(
      context,
      ColorDetailsViewCreator(color: _userColors[index]),
    );
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.userPalettes.indexOf(tileViewState);
    openScreen(
      context,
      PaletteDetailsViewCreator(palette: _userPalettes[index]),
    );
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.userPatterns.indexOf(tileViewState);
    openScreen(
      context,
      PatternDetailsViewCreator(pattern: _userPatterns[index]),
    );
  }

  void showUserColorsView(BuildContext context) {
    if (_user.userName == null) return;
    openScreen(
      context,
      UserColorsViewCreator(userName: _user.userName!),
    );
  }

  void showUserPalettesView(BuildContext context) {
    if (_user.userName == null) return;
    openScreen(
      context,
      UserPalettesViewCreator(userName: _user.userName!),
    );
  }

  void showUserPatternsView(BuildContext context) {
    if (_user.userName == null) return;
    openScreen(
      context,
      UserPatternsViewCreator(userName: _user.userName!),
    );
  }
}
