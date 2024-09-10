import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class PaletteTileViewState extends Equatable {
  final String title;
  final int numViews;
  final int numVotes;
  final IList<String> hexs;
  final IList<double> widths;

  const PaletteTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hexs,
    required this.widths,
  });

  @override
  List<Object?> get props => [title, numViews, numVotes, hexs, widths];

  PaletteTileViewState copyWith({
    String? title,
    int? numViews,
    int? numVotes,
    IList<String>? hexs,
    IList<double>? widths,
  }) {
    return PaletteTileViewState(
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      hexs: hexs ?? this.hexs,
      widths: widths ?? this.widths,
    );
  }

  factory PaletteTileViewState.fromColourloverPalette(
    ColourloversPalette palette,
  ) {
    return PaletteTileViewState(
      title: palette.title ?? '',
      numViews: palette.numViews ?? 0,
      numVotes: palette.numVotes ?? 0,
      hexs: IList(palette.colors ?? []),
      widths: IList(palette.colorWidths ?? []),
    );
  }
}

const defaultPaletteTileViewState = PaletteTileViewState(
  title: '',
  numViews: 0,
  numVotes: 0,
  hexs: IList.empty(),
  widths: IList.empty(),
);
