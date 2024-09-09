import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';

@immutable
class PaletteDetailsViewState {
  final bool isLoading;
  final String id;
  final String title;
  final List<String> colors;
  final List<double> colorWidths;
  final List<ColorTileViewState> colorViewStates;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewState user;
  final List<PaletteTileViewState> relatedPalettes;
  final List<PatternTileViewState> relatedPatterns;

  const PaletteDetailsViewState({
    required this.isLoading,
    required this.id,
    required this.title,
    required this.colors,
    required this.colorWidths,
    required this.colorViewStates,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });

  factory PaletteDetailsViewState.empty() {
    return PaletteDetailsViewState(
      isLoading: true,
      id: '',
      title: '',
      colors: const [],
      colorWidths: const [],
      colorViewStates: const [],
      numViews: '',
      numVotes: '',
      rank: '',
      user: UserTileViewState.empty(),
      relatedPalettes: const [],
      relatedPatterns: const [],
    );
  }
}
