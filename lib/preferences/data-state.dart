import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

@immutable
class PreferencesDataState extends Equatable {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;

  const PreferencesDataState({
    required this.themeMode,
    required this.flexScheme,
  });

  @override
  List<Object> get props => [themeMode, flexScheme];

  PreferencesDataState copyWith({
    ThemeMode? themeMode,
    FlexScheme? flexScheme,
  }) {
    return PreferencesDataState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {'themeMode': themeMode.name, 'theme': flexScheme.name};
  }

  factory PreferencesDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'themeMode': final String themeMode, 'theme': final String flexScheme} =>
        PreferencesDataState(
          themeMode: ThemeMode.values.byName(themeMode),
          flexScheme: FlexScheme.values.byName(flexScheme),
        ),
      _ => defaultPreferencesDataState,
    };
  }
}

const defaultThemeMode = ThemeMode.dark;
const defaultFlexScheme = FlexScheme.purpleM3;

const defaultPreferencesDataState = PreferencesDataState(
  themeMode: defaultThemeMode,
  flexScheme: defaultFlexScheme,
);
