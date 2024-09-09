import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class PatternDetailsViewState extends Equatable {
  final bool isLoading;
  final String id;
  final String title;
  final IList<String> colors;
  final IList<ColorTileViewState> colorViewStates;
  final String imageUrl;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewState user;
  final IList<PaletteTileViewState> relatedPalettes;
  final IList<PatternTileViewState> relatedPatterns;

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

  @override
  List<Object?> get props => [
        isLoading,
        id,
        title,
        colors,
        colorViewStates,
        imageUrl,
        numViews,
        numVotes,
        rank,
        user,
        relatedPalettes,
        relatedPatterns,
      ];

  PatternDetailsViewState copyWith({
    bool? isLoading,
    String? id,
    String? title,
    IList<String>? colors,
    IList<ColorTileViewState>? colorViewStates,
    String? imageUrl,
    String? numViews,
    String? numVotes,
    String? rank,
    UserTileViewState? user,
    IList<PaletteTileViewState>? relatedPalettes,
    IList<PatternTileViewState>? relatedPatterns,
  }) {
    return PatternDetailsViewState(
      isLoading: isLoading ?? this.isLoading,
      id: id ?? this.id,
      title: title ?? this.title,
      colors: colors ?? this.colors,
      colorViewStates: colorViewStates ?? this.colorViewStates,
      imageUrl: imageUrl ?? this.imageUrl,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      rank: rank ?? this.rank,
      user: user ?? this.user,
      relatedPalettes: relatedPalettes ?? this.relatedPalettes,
      relatedPatterns: relatedPatterns ?? this.relatedPatterns,
    );
  }
}

const defaultPatternDetailsViewState = PatternDetailsViewState(
  isLoading: true,
  id: '',
  title: '',
  colors: IList.empty(),
  colorViewStates: IList.empty(),
  imageUrl: '',
  numViews: '',
  numVotes: '',
  rank: '',
  user: defaultUserTileViewState,
  relatedPalettes: IList.empty(),
  relatedPatterns: IList.empty(),
);
