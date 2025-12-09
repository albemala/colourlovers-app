import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ColorTileViewState extends Equatable {
  final String id;
  final String title;
  final int numViews;
  final int numVotes;
  final String hex;

  const ColorTileViewState({
    required this.id,
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hex,
  });

  factory ColorTileViewState.initial() {
    return const ColorTileViewState(
      id: '',
      title: '',
      numViews: 0,
      numVotes: 0,
      hex: '',
    );
  }

  @override
  List<Object> get props => [id, title, numViews, numVotes, hex];

  ColorTileViewState copyWith({
    String? id,
    String? title,
    int? numViews,
    int? numVotes,
    String? hex,
  }) {
    return ColorTileViewState(
      id: id ?? this.id,
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      hex: hex ?? this.hex,
    );
  }

  factory ColorTileViewState.fromColourloverColor(ColourloversColor? color) {
    if (color == null) return ColorTileViewState.initial();
    return ColorTileViewState(
      id: color.id?.toString() ?? '',
      title: color.title ?? '',
      numViews: color.numViews ?? 0,
      numVotes: color.numVotes ?? 0,
      hex: color.hex ?? '',
    );
  }
}
