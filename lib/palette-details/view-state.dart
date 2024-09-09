import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class PaletteDetailsViewState extends Equatable {
  final bool isLoading;
  final String id;
  final String title;
  final IList<String> colors;
  final IList<double> colorWidths;
  final IList<ColorTileViewState> colorViewStates;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewState user;
  final IList<PaletteTileViewState> relatedPalettes;
  final IList<PatternTileViewState> relatedPatterns;

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

  @override
  List<Object?> get props => [
        isLoading,
        id,
        title,
        colors,
        colorWidths,
        colorViewStates,
        numViews,
        numVotes,
        rank,
        user,
        relatedPalettes,
        relatedPatterns,
      ];

  PaletteDetailsViewState copyWith({
    bool? isLoading,
    String? id,
    String? title,
    IList<String>? colors,
    IList<double>? colorWidths,
    IList<ColorTileViewState>? colorViewStates,
    String? numViews,
    String? numVotes,
    String? rank,
    UserTileViewState? user,
    IList<PaletteTileViewState>? relatedPalettes,
    IList<PatternTileViewState>? relatedPatterns,
  }) {
    return PaletteDetailsViewState(
      isLoading: isLoading ?? this.isLoading,
      id: id ?? this.id,
      title: title ?? this.title,
      colors: colors ?? this.colors,
      colorWidths: colorWidths ?? this.colorWidths,
      colorViewStates: colorViewStates ?? this.colorViewStates,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      rank: rank ?? this.rank,
      user: user ?? this.user,
      relatedPalettes: relatedPalettes ?? this.relatedPalettes,
      relatedPatterns: relatedPatterns ?? this.relatedPatterns,
    );
  }
}

const defaultPaletteDetailsViewState = PaletteDetailsViewState(
  isLoading: true,
  id: '',
  title: '',
  colors: IList.empty(),
  colorWidths: IList.empty(),
  colorViewStates: IList.empty(),
  numViews: '',
  numVotes: '',
  rank: '',
  user: defaultUserTileViewState,
  relatedPalettes: IList.empty(),
  relatedPatterns: IList.empty(),
);
