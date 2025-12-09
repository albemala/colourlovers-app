import 'dart:async';

import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:colourlovers_app/preferences/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesViewController extends Cubit<PreferencesViewState> {
  final PreferencesDataController _preferencesDataController;

  StreamSubscription<PreferencesDataState>?
  _preferencesDataControllerSubscription;

  factory PreferencesViewController.fromContext(BuildContext context) {
    return PreferencesViewController(context.read<PreferencesDataController>());
  }

  PreferencesViewController(this._preferencesDataController)
    : super(PreferencesViewState.initial()) {
    _preferencesDataControllerSubscription = _preferencesDataController.stream
        .listen((_) {
          _updateState();
        });
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _updateState();
  }

  @override
  Future<void> close() {
    _preferencesDataControllerSubscription?.cancel();
    return super.close();
  }

  void _updateState() {
    emit(
      state.copyWith(
        themeMode: _preferencesDataController.state.themeMode,
        flexScheme: _preferencesDataController.state.flexScheme,
      ),
    );
  }

  void setThemeMode(ThemeMode themeMode) {
    _preferencesDataController.themeMode = themeMode;
  }

  void setFlexScheme(FlexScheme flexScheme) {
    _preferencesDataController.flexScheme = flexScheme;
  }
}
