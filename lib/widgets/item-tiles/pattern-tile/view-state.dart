import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PatternTileViewState extends Equatable {
  final String id;
  final String title;
  final int numViews;
  final int numVotes;
  final String imageUrl;

  const PatternTileViewState({
    required this.id,
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.imageUrl,
  });

  factory PatternTileViewState.initial() {
    return const PatternTileViewState(
      id: '',
      title: '',
      numViews: 0,
      numVotes: 0,
      imageUrl: '',
    );
  }

  @override
  List<Object> get props => [id, title, numViews, numVotes, imageUrl];

  PatternTileViewState copyWith({
    String? id,
    String? title,
    int? numViews,
    int? numVotes,
    String? imageUrl,
  }) {
    return PatternTileViewState(
      id: id ?? this.id,
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory PatternTileViewState.fromColourloverPattern(
    ColourloversPattern? pattern,
  ) {
    if (pattern == null) return PatternTileViewState.initial();
    return PatternTileViewState(
      id: pattern.id?.toString() ?? '',
      title: pattern.title ?? '',
      numViews: pattern.numViews ?? 0,
      numVotes: pattern.numVotes ?? 0,
      imageUrl: pattern.imageUrl ?? '',
    );
  }
}
