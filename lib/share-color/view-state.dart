import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ShareColorViewState extends Equatable {
  final String hex;
  final String imageUrl;

  const ShareColorViewState({
    required this.hex,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [hex, imageUrl];

  ShareColorViewState copyWith({
    String? hex,
    String? imageUrl,
  }) {
    return ShareColorViewState(
      hex: hex ?? this.hex,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ShareColorViewState.fromColourloversColor(ColourloversColor color) {
    return ShareColorViewState(
      hex: color.hex ?? '',
      imageUrl: httpToHttps(color.imageUrl ?? ''),
    );
  }
}

const defaultShareColorViewState = ShareColorViewState(
  hex: '',
  imageUrl: '',
);
