import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

@immutable
class PreferencesViewState extends Equatable {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;

  const PreferencesViewState({
    required this.themeMode,
    required this.flexScheme,
  });

  @override
  List<Object?> get props => [
        themeMode,
        flexScheme,
      ];

  PreferencesViewState copyWith({
    ThemeMode? themeMode,
    FlexScheme? flexScheme,
  }) {
    return PreferencesViewState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }
}

const defaultPreferencesViewState = PreferencesViewState(
  themeMode: ThemeMode.dark,
  flexScheme: FlexScheme.material,
);
