import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:flutter/material.dart';

@immutable
class SharePatternViewState {
  final List<String> colors;
  final String imageUrl;
  final String templateUrl;

  const SharePatternViewState({
    required this.colors,
    required this.imageUrl,
    required this.templateUrl,
  });

  factory SharePatternViewState.initialState() {
    return const SharePatternViewState(
      colors: [],
      imageUrl: '',
      templateUrl: '',
    );
  }

  factory SharePatternViewState.fromColourloversPattern(
    ColourloversPattern pattern,
  ) {
    return SharePatternViewState(
      colors: pattern.colors ?? [],
      imageUrl: httpToHttps(pattern.imageUrl ?? ''),
      templateUrl: httpToHttps(pattern.template?.url ?? ''),
    );
  }
}
