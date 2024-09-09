import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class SharePaletteViewState extends Equatable {
  final IList<String> colors;
  final IList<double> colorWidths;
  final String imageUrl;

  const SharePaletteViewState({
    required this.colors,
    required this.colorWidths,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [colors, colorWidths, imageUrl];

  SharePaletteViewState copyWith({
    IList<String>? colors,
    IList<double>? colorWidths,
    String? imageUrl,
  }) {
    return SharePaletteViewState(
      colors: colors ?? this.colors,
      colorWidths: colorWidths ?? this.colorWidths,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory SharePaletteViewState.fromColourloversPalette(
    ColourloversPalette palette,
  ) {
    return SharePaletteViewState(
      colors: IList(palette.colors ?? []),
      colorWidths: IList(palette.colorWidths ?? []),
      imageUrl: httpToHttps(palette.imageUrl ?? ''),
    );
  }
}

const defaultSharePaletteViewState = SharePaletteViewState(
  colors: IList.empty(),
  colorWidths: IList.empty(),
  imageUrl: '',
);
