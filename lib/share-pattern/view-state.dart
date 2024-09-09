import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class SharePatternViewState extends Equatable {
  final IList<String> colors;
  final String imageUrl;
  final String templateUrl;

  const SharePatternViewState({
    required this.colors,
    required this.imageUrl,
    required this.templateUrl,
  });

  @override
  List<Object?> get props => [colors, imageUrl, templateUrl];

  SharePatternViewState copyWith({
    IList<String>? colors,
    String? imageUrl,
    String? templateUrl,
  }) {
    return SharePatternViewState(
      colors: colors ?? this.colors,
      imageUrl: imageUrl ?? this.imageUrl,
      templateUrl: templateUrl ?? this.templateUrl,
    );
  }

  factory SharePatternViewState.fromColourloversPattern(
    ColourloversPattern pattern,
  ) {
    return SharePatternViewState(
      colors: IList(pattern.colors ?? []),
      imageUrl: httpToHttps(pattern.imageUrl ?? ''),
      templateUrl: httpToHttps(pattern.template?.url ?? ''),
    );
  }
}

const defaultSharePatternViewState = SharePatternViewState(
  colors: IList.empty(),
  imageUrl: '',
  templateUrl: '',
);
