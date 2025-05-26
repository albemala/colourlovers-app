import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/formatters.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/user-colors/view.dart';
import 'package:colourlovers_app/user-details/view-state.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/user-palettes/view.dart';
import 'package:colourlovers_app/user-patterns/view.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsViewController extends Cubit<UserDetailsViewState> {
  final ColourloversLover _user;
  final ColourloversApiClient _client;
  List<ColourloversColor> _userColors = [];
  List<ColourloversPalette> _userPalettes = [];
  List<ColourloversPattern> _userPatterns = [];

  factory UserDetailsViewController.fromContext(
    BuildContext context, {
    required ColourloversLover user,
  }) {
    return UserDetailsViewController(user, ColourloversApiClient());
  }

  UserDetailsViewController(this._user, this._client)
    : super(defaultUserDetailsViewState) {
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
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
      state.copyWith(
        isLoading: false,
        userName: _user.userName ?? '',
        numColors: _user.numColors.formatted(),
        numPalettes: _user.numPalettes.formatted(),
        numPatterns: _user.numPatterns.formatted(),
        rating: _user.rating.formatted(),
        numLovers: _user.numLovers.formatted(),
        location: _user.location ?? '',
        dateRegistered: _user.dateRegistered.formatted(),
        dateLastActive: _user.dateLastActive.formatted(),
        userColors: mapToTileViewState(
          _userColors,
          ColorTileViewState.fromColourloverColor,
        ),
        userPalettes: mapToTileViewState(
          _userPalettes,
          PaletteTileViewState.fromColourloverPalette,
        ),
        userPatterns: mapToTileViewState(
          _userPatterns,
          PatternTileViewState.fromColourloverPattern,
        ),
      ),
    );
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewState tileViewState,
  ) {
    final index = state.userColors.indexOf(tileViewState);
    final color = _userColors[index];
    openScreen<void>(context, ColorDetailsViewCreator(color: color));
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewState tileViewState,
  ) {
    final index = state.userPalettes.indexOf(tileViewState);
    final palette = _userPalettes[index];
    openScreen<void>(context, PaletteDetailsViewCreator(palette: palette));
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewState tileViewState,
  ) {
    final index = state.userPatterns.indexOf(tileViewState);
    final pattern = _userPatterns[index];
    openScreen<void>(context, PatternDetailsViewCreator(pattern: pattern));
  }

  void showUserColorsView(BuildContext context) {
    final userName = _user.userName;
    if (userName == null) return;
    openScreen<void>(context, UserColorsViewCreator(userName: userName));
  }

  void showUserPalettesView(BuildContext context) {
    final userName = _user.userName;
    if (userName == null) return;
    openScreen<void>(context, UserPalettesViewCreator(userName: userName));
  }

  void showUserPatternsView(BuildContext context) {
    final userName = _user.userName;
    if (userName == null) return;
    openScreen<void>(context, UserPatternsViewCreator(userName: userName));
  }
}
