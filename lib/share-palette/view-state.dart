import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:flutter/material.dart';

@immutable
class SharePaletteViewState {
  final List<String> colors;
  final List<double> colorWidths;
  final String imageUrl;

  const SharePaletteViewState({
    required this.colors,
    required this.colorWidths,
    required this.imageUrl,
  });

  factory SharePaletteViewState.initialState() {
    return const SharePaletteViewState(
      colors: [],
      colorWidths: [],
      imageUrl: '',
    );
  }

  factory SharePaletteViewState.fromColourloversPalette(
    ColourloversPalette palette,
  ) {
    return SharePaletteViewState(
      colors: palette.colors ?? [],
      colorWidths: palette.colorWidths ?? [],
      imageUrl: httpToHttps(palette.imageUrl ?? ''),
    );
  }
}
