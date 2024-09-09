import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ColorRgbViewState extends Equatable {
  final double red;
  final double green;
  final double blue;

  const ColorRgbViewState({
    required this.red,
    required this.green,
    required this.blue,
  });

  @override
  List<Object?> get props => [red, green, blue];

  ColorRgbViewState copyWith({
    double? red,
    double? green,
    double? blue,
  }) {
    return ColorRgbViewState(
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
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
class ColorHsvViewState extends Equatable {
  final double hue;
  final double saturation;
  final double value;

  const ColorHsvViewState({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  @override
  List<Object?> get props => [hue, saturation, value];

  ColorHsvViewState copyWith({
    double? hue,
    double? saturation,
    double? value,
  }) {
    return ColorHsvViewState(
      hue: hue ?? this.hue,
      saturation: saturation ?? this.saturation,
      value: value ?? this.value,
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
class ColorDetailsViewState extends Equatable {
  final bool isLoading;
  final String title;
  final String hex;
  final ColorRgbViewState rgb;
  final ColorHsvViewState hsv;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewState user;
  final IList<ColorTileViewState> relatedColors;
  final IList<PaletteTileViewState> relatedPalettes;
  final IList<PatternTileViewState> relatedPatterns;

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

  @override
  List<Object?> get props => [
        isLoading,
        title,
        hex,
        rgb,
        hsv,
        numViews,
        numVotes,
        rank,
        user,
        relatedColors,
        relatedPalettes,
        relatedPatterns,
      ];

  ColorDetailsViewState copyWith({
    bool? isLoading,
    String? title,
    String? hex,
    ColorRgbViewState? rgb,
    ColorHsvViewState? hsv,
    String? numViews,
    String? numVotes,
    String? rank,
    UserTileViewState? user,
    IList<ColorTileViewState>? relatedColors,
    IList<PaletteTileViewState>? relatedPalettes,
    IList<PatternTileViewState>? relatedPatterns,
  }) {
    return ColorDetailsViewState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      hex: hex ?? this.hex,
      rgb: rgb ?? this.rgb,
      hsv: hsv ?? this.hsv,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      rank: rank ?? this.rank,
      user: user ?? this.user,
      relatedColors: relatedColors ?? this.relatedColors,
      relatedPalettes: relatedPalettes ?? this.relatedPalettes,
      relatedPatterns: relatedPatterns ?? this.relatedPatterns,
    );
  }
}

const defaultColorRgbViewState = ColorRgbViewState(
  red: 0,
  green: 0,
  blue: 0,
);

const defaultColorHsvViewState = ColorHsvViewState(
  hue: 0,
  saturation: 0,
  value: 0,
);

const defaultColorDetailsViewState = ColorDetailsViewState(
  isLoading: true,
  title: '',
  hex: '',
  rgb: defaultColorRgbViewState,
  hsv: defaultColorHsvViewState,
  numViews: '',
  numVotes: '',
  rank: '',
  user: defaultUserTileViewState,
  relatedColors: IList.empty(),
  relatedPalettes: IList.empty(),
  relatedPatterns: IList.empty(),
);
