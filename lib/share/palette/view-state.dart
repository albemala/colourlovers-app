import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class SharePaletteViewState extends Equatable {
  final IList<String> colors;
  final IList<double> colorWidths;
  final String imageUrl;
  final IList<BackgroundBlob> backgroundBlobs;

  const SharePaletteViewState({
    required this.colors,
    required this.colorWidths,
    required this.imageUrl,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [colors, colorWidths, imageUrl, backgroundBlobs];

  SharePaletteViewState copyWith({
    IList<String>? colors,
    IList<double>? colorWidths,
    String? imageUrl,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return SharePaletteViewState(
      colors: colors ?? this.colors,
      colorWidths: colorWidths ?? this.colorWidths,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultSharePaletteViewState = SharePaletteViewState(
  colors: IList.empty(),
  colorWidths: IList.empty(),
  imageUrl: '',
  backgroundBlobs: IList.empty(),
);
