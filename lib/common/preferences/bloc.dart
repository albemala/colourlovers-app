import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _defaultThemeMode = ThemeMode.dark;

@immutable
class PreferencesBlocModel {
  final ThemeMode themeMode;

  const PreferencesBlocModel({
    required this.themeMode,
  });

  factory PreferencesBlocModel.initialState() {
    return const PreferencesBlocModel(
      themeMode: _defaultThemeMode,
    );
  }
}

class PreferencesBloc extends Cubit<PreferencesBlocModel> {
  factory PreferencesBloc.fromContext(BuildContext context) {
    return PreferencesBloc();
  }

  ThemeMode _themeMode = _defaultThemeMode;

  PreferencesBloc()
      : super(
          PreferencesBlocModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {}

  void toggleThemeMode() {
    setThemeMode(
      state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _updateState();
  }

  void _updateState() {
    emit(
      PreferencesBlocModel(
        themeMode: _themeMode,
      ),
    );
  }
}
