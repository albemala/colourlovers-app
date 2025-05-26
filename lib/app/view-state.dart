import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

@immutable
class AppViewState extends Equatable {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;

  const AppViewState({required this.themeMode, required this.flexScheme});

  @override
  List<Object?> get props => [themeMode, flexScheme];

  AppViewState copyWith({ThemeMode? themeMode, FlexScheme? flexScheme}) {
    return AppViewState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }
}

const defaultAppViewState = AppViewState(
  themeMode: defaultThemeMode,
  flexScheme: defaultFlexScheme,
);
