import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ExploreViewState extends Equatable {
  final IList<BackgroundBlob> backgroundBlobs;

  const ExploreViewState({required this.backgroundBlobs});

  @override
  List<Object> get props => [backgroundBlobs];

  ExploreViewState copyWith({IList<BackgroundBlob>? backgroundBlobs}) {
    return ExploreViewState(
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultExploreViewState = ExploreViewState(
  backgroundBlobs: IList.empty(),
);
