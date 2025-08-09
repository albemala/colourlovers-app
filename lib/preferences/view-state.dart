import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

@immutable
class PreferencesViewState extends Equatable {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;
  final IList<BackgroundBlob> backgroundBlobs;

  const PreferencesViewState({
    required this.themeMode,
    required this.flexScheme,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [themeMode, flexScheme, backgroundBlobs];

  PreferencesViewState copyWith({
    ThemeMode? themeMode,
    FlexScheme? flexScheme,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return PreferencesViewState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultPreferencesViewState = PreferencesViewState(
  themeMode: ThemeMode.dark,
  flexScheme: FlexScheme.material,
  backgroundBlobs: IList.empty(),
);
