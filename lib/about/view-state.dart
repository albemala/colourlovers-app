import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class AboutViewState extends Equatable {
  final String appVersion;
  final IList<BackgroundBlob> backgroundBlobs;

  const AboutViewState({
    required this.appVersion,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [appVersion, backgroundBlobs];

  AboutViewState copyWith({
    String? appVersion,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return AboutViewState(
      appVersion: appVersion ?? this.appVersion,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }

  factory AboutViewState.initial() {
    return const AboutViewState(
      appVersion: '',
      backgroundBlobs: IList.empty(),
    );
  }
}
