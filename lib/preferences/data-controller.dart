import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

class PreferencesDataController extends StoredCubit<PreferencesDataState> {
  PreferencesDataController() : super(PreferencesDataState.initial());

  factory PreferencesDataController.fromContext(BuildContext _) {
    return PreferencesDataController();
  }

  @override
  Future<void> migrateData() async {}

  @override
  String get storeName => 'preferences';

  @override
  PreferencesDataState fromMap(Map<String, dynamic> json) {
    return PreferencesDataState.fromMap(json);
  }

  @override
  Map<String, dynamic> toMap(PreferencesDataState state) {
    return state.toMap();
  }

  ThemeMode get themeMode => state.themeMode;
  set themeMode(ThemeMode mode) => emit(state.copyWith(themeMode: mode));

  FlexScheme get flexScheme => state.flexScheme;
  set flexScheme(FlexScheme scheme) => emit(state.copyWith(flexScheme: scheme));
}
