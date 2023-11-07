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
    return PreferencesBloc(
        // TODO
        // ConductorStorage(
        // context.read<LocalStorageConductor>(),
        // ),
        );
  }

  ThemeMode _themeMode = _defaultThemeMode;

  PreferencesBloc()
      : super(
          PreferencesBlocModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    // await load();
    // themeMode.addListener(_updateAndSave);
  }

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

/*
  void _updateAndSave() {
    save();
  }

  @override
  String get storeName => 'preferences';

  static const _themeModeKey = 'themeMode';

  @override
  Map<String, dynamic> toMap() {
    return {
      _themeModeKey: themeMode.value.index,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    final themeModeIndex = map[_themeModeKey] as int? ?? ThemeMode.light.index;
    themeMode.value = ThemeMode.values[themeModeIndex];
  }
*/
}
