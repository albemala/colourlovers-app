import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ColorTileViewState extends Equatable {
  final String title;
  final int numViews;
  final int numVotes;
  final String hex;

  const ColorTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hex,
  });

  @override
  List<Object?> get props => [title, numViews, numVotes, hex];

  ColorTileViewState copyWith({
    String? title,
    int? numViews,
    int? numVotes,
    String? hex,
  }) {
    return ColorTileViewState(
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      hex: hex ?? this.hex,
    );
  }

  factory ColorTileViewState.fromColourloverColor(
    ColourloversColor color,
  ) {
    return ColorTileViewState(
      title: color.title ?? '',
      numViews: color.numViews ?? 0,
      numVotes: color.numVotes ?? 0,
      hex: color.hex ?? '',
    );
  }
}

const defaultColorTileViewState = ColorTileViewState(
  title: '',
  numViews: 0,
  numVotes: 0,
  hex: '',
);
