import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';

@immutable
class ColorRgbViewState {
  final double red;
  final double green;
  final double blue;

  const ColorRgbViewState({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory ColorRgbViewState.empty() {
    return const ColorRgbViewState(
      red: 0,
      green: 0,
      blue: 0,
    );
  }

  factory ColorRgbViewState.fromColourloverRgb(Rgb rgb) {
    return ColorRgbViewState(
      red: rgb.red?.toDouble() ?? 0,
      green: rgb.green?.toDouble() ?? 0,
      blue: rgb.blue?.toDouble() ?? 0,
    );
  }
}

@immutable
class ColorHsvViewState {
  final double hue;
  final double saturation;
  final double value;

  const ColorHsvViewState({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  factory ColorHsvViewState.empty() {
    return const ColorHsvViewState(
      hue: 0,
      saturation: 0,
      value: 0,
    );
  }

  factory ColorHsvViewState.fromColourloverHsv(Hsv hsv) {
    return ColorHsvViewState(
      hue: hsv.hue?.toDouble() ?? 0,
      saturation: hsv.saturation?.toDouble() ?? 0,
      value: hsv.value?.toDouble() ?? 0,
    );
  }
}

@immutable
class ColorDetailsViewState {
  final bool isLoading;
  final String title;
  final String hex;
  final ColorRgbViewState rgb;
  final ColorHsvViewState hsv;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewState user;
  final List<ColorTileViewState> relatedColors;
  final List<PaletteTileViewState> relatedPalettes;
  final List<PatternTileViewState> relatedPatterns;

  const ColorDetailsViewState({
    required this.isLoading,
    required this.title,
    required this.hex,
    required this.rgb,
    required this.hsv,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedColors,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });

  factory ColorDetailsViewState.empty() {
    return ColorDetailsViewState(
      isLoading: true,
      title: '',
      hex: '',
      rgb: ColorRgbViewState.empty(),
      hsv: ColorHsvViewState.empty(),
      numViews: '',
      numVotes: '',
      rank: '',
      user: UserTileViewState.empty(),
      relatedColors: const [],
      relatedPalettes: const [],
      relatedPatterns: const [],
    );
  }
}
