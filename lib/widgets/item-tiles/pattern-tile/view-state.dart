import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PatternTileViewState extends Equatable {
  final String title;
  final int numViews;
  final int numVotes;
  final String imageUrl;

  const PatternTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [title, numViews, numVotes, imageUrl];

  PatternTileViewState copyWith({
    String? title,
    int? numViews,
    int? numVotes,
    String? imageUrl,
  }) {
    return PatternTileViewState(
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory PatternTileViewState.fromColourloverPattern(
    ColourloversPattern pattern,
  ) {
    return PatternTileViewState(
      title: pattern.title ?? '',
      numViews: pattern.numViews ?? 0,
      numVotes: pattern.numVotes ?? 0,
      imageUrl: pattern.imageUrl ?? '',
    );
  }
}

const defaultPatternTileViewState = PatternTileViewState(
  title: '',
  numViews: 0,
  numVotes: 0,
  imageUrl: '',
);
