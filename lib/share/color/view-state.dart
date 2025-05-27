import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ShareColorViewState extends Equatable {
  final String hex;
  final String imageUrl;
  final IList<BackgroundBlob> backgroundBlobs;

  const ShareColorViewState({
    required this.hex,
    required this.imageUrl,
    required this.backgroundBlobs,
  });

  @override
  List<Object?> get props => [hex, imageUrl, backgroundBlobs];

  ShareColorViewState copyWith({
    String? hex,
    String? imageUrl,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return ShareColorViewState(
      hex: hex ?? this.hex,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultShareColorViewState = ShareColorViewState(
  hex: '',
  imageUrl: '',
  backgroundBlobs: IList.empty(),
);
