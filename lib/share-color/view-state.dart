import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:flutter/material.dart';

@immutable
class ShareColorViewState {
  final String hex;
  final String imageUrl;

  const ShareColorViewState({
    required this.hex,
    required this.imageUrl,
  });

  factory ShareColorViewState.initialState() {
    return const ShareColorViewState(
      hex: '',
      imageUrl: '',
    );
  }

  factory ShareColorViewState.fromColourloversColor(ColourloversColor color) {
    return ShareColorViewState(
      hex: color.hex ?? '',
      imageUrl: httpToHttps(color.imageUrl ?? ''),
    );
  }
}
