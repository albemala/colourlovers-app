import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

@immutable
class AppViewState extends Equatable {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;
  final bool isLoading;

  const AppViewState({
    required this.themeMode,
    required this.flexScheme,
    required this.isLoading,
  });

  @override
  List<Object> get props => [themeMode, flexScheme, isLoading];

  AppViewState copyWith({
    ThemeMode? themeMode,
    FlexScheme? flexScheme,
    bool? isLoading,
  }) {
    return AppViewState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

const defaultAppViewState = AppViewState(
  themeMode: defaultThemeMode,
  flexScheme: defaultFlexScheme,
  isLoading: false,
);
