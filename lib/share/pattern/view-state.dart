import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class SharePatternViewState extends Equatable {
  final IList<String> colors;
  final String imageUrl;
  final String templateUrl;
  final IList<BackgroundBlob> backgroundBlobs;

  const SharePatternViewState({
    required this.colors,
    required this.imageUrl,
    required this.templateUrl,
    required this.backgroundBlobs,
  });

  @override
  List<Object?> get props => [colors, imageUrl, templateUrl, backgroundBlobs];

  SharePatternViewState copyWith({
    IList<String>? colors,
    String? imageUrl,
    String? templateUrl,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return SharePatternViewState(
      colors: colors ?? this.colors,
      imageUrl: imageUrl ?? this.imageUrl,
      templateUrl: templateUrl ?? this.templateUrl,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultSharePatternViewState = SharePatternViewState(
  colors: IList.empty(),
  imageUrl: '',
  templateUrl: '',
  backgroundBlobs: IList.empty(),
);
