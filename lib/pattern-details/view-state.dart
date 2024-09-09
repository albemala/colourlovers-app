import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';

@immutable
class PatternDetailsViewState {
  final bool isLoading;
  final String id;
  final String title;
  final List<String> colors;
  final List<ColorTileViewState> colorViewStates;
  final String imageUrl;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewState user;
  final List<PaletteTileViewState> relatedPalettes;
  final List<PatternTileViewState> relatedPatterns;

  const PatternDetailsViewState({
    required this.isLoading,
    required this.id,
    required this.title,
    required this.colors,
    required this.colorViewStates,
    required this.imageUrl,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });

  factory PatternDetailsViewState.empty() {
    return PatternDetailsViewState(
      isLoading: true,
      id: '',
      title: '',
      colors: const [],
      colorViewStates: const [],
      imageUrl: '',
      numViews: '',
      numVotes: '',
      rank: '',
      user: UserTileViewState.empty(),
      relatedPalettes: const [],
      relatedPatterns: const [],
    );
  }
}
