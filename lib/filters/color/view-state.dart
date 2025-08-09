import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ColorFiltersViewState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final int hueMin;
  final int hueMax;
  final int brightnessMin;
  final int brightnessMax;
  final String colorName;
  final String userName;
  final IList<BackgroundBlob> backgroundBlobs;

  const ColorFiltersViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.hueMin,
    required this.hueMax,
    required this.brightnessMin,
    required this.brightnessMax,
    required this.colorName,
    required this.userName,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [
    showCriteria,
    sortBy,
    sortOrder,
    hueMin,
    hueMax,
    brightnessMin,
    brightnessMax,
    colorName,
    userName,
    backgroundBlobs,
  ];

  ColorFiltersViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    int? hueMin,
    int? hueMax,
    int? brightnessMin,
    int? brightnessMax,
    String? colorName,
    String? userName,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return ColorFiltersViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      hueMin: hueMin ?? this.hueMin,
      hueMax: hueMax ?? this.hueMax,
      brightnessMin: brightnessMin ?? this.brightnessMin,
      brightnessMax: brightnessMax ?? this.brightnessMax,
      colorName: colorName ?? this.colorName,
      userName: userName ?? this.userName,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultColorFiltersViewState = ColorFiltersViewState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  hueMin: 0,
  hueMax: 359,
  brightnessMin: 0,
  brightnessMax: 99,
  colorName: '',
  userName: '',
  backgroundBlobs: IList.empty(),
);
