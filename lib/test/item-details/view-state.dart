import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ItemDetailsViewState extends Equatable {
  final ColourloversColor? color;
  final ColourloversPalette? palette;
  final ColourloversPattern? pattern;
  final ColourloversLover? user;

  const ItemDetailsViewState({
    this.color,
    this.palette,
    this.pattern,
    this.user,
  });

  @override
  List<Object?> get props => [color, palette, pattern, user];

  ItemDetailsViewState copyWith({
    ColourloversColor? color,
    ColourloversPalette? palette,
    ColourloversPattern? pattern,
    ColourloversLover? user,
  }) {
    return ItemDetailsViewState(
      color: color ?? this.color,
      palette: palette ?? this.palette,
      pattern: pattern ?? this.pattern,
      user: user ?? this.user,
    );
  }
}

const defaultItemDetailsViewState = ItemDetailsViewState();
