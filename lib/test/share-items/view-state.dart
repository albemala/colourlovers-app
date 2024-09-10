import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ShareItemsViewState extends Equatable {
  final ColourloversColor? color;
  final ColourloversPalette? palette;
  final ColourloversPattern? pattern;
  final ColourloversLover? user;

  const ShareItemsViewState({
    this.color,
    this.palette,
    this.pattern,
    this.user,
  });

  @override
  List<Object?> get props => [color, palette, pattern, user];

  ShareItemsViewState copyWith({
    ColourloversColor? color,
    ColourloversPalette? palette,
    ColourloversPattern? pattern,
    ColourloversLover? user,
  }) {
    return ShareItemsViewState(
      color: color ?? this.color,
      palette: palette ?? this.palette,
      pattern: pattern ?? this.pattern,
      user: user ?? this.user,
    );
  }
}

const defaultShareItemsViewState = ShareItemsViewState();
