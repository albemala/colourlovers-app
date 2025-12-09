import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ColorFiltersDataState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final int hueMin;
  final int hueMax;
  final int brightnessMin;
  final int brightnessMax;
  final String colorName;
  final String userName;

  const ColorFiltersDataState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.hueMin,
    required this.hueMax,
    required this.brightnessMin,
    required this.brightnessMax,
    required this.colorName,
    required this.userName,
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
  ];

  ColorFiltersDataState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    int? hueMin,
    int? hueMax,
    int? brightnessMin,
    int? brightnessMax,
    String? colorName,
    String? userName,
  }) {
    return ColorFiltersDataState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      hueMin: hueMin ?? this.hueMin,
      hueMax: hueMax ?? this.hueMax,
      brightnessMin: brightnessMin ?? this.brightnessMin,
      brightnessMax: brightnessMax ?? this.brightnessMax,
      colorName: colorName ?? this.colorName,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showCriteria': showCriteria.name,
      'sortBy': sortBy.name,
      'sortOrder': sortOrder.name,
      'hueMin': hueMin,
      'hueMax': hueMax,
      'brightnessMin': brightnessMin,
      'brightnessMax': brightnessMax,
      'colorName': colorName,
      'userName': userName,
    };
  }

  factory ColorFiltersDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'showCriteria': final String showCriteria,
        'sortBy': final String sortBy,
        'sortOrder': final String sortOrder,
        'hueMin': final int hueMin,
        'hueMax': final int hueMax,
        'brightnessMin': final int brightnessMin,
        'brightnessMax': final int brightnessMax,
        'colorName': final String colorName,
        'userName': final String userName,
      } =>
        ColorFiltersDataState(
          showCriteria: ContentShowCriteria.values.byName(showCriteria),
          sortBy: ColourloversRequestOrderBy.values.byName(sortBy),
          sortOrder: ColourloversRequestSortBy.values.byName(sortOrder),
          hueMin: hueMin,
          hueMax: hueMax,
          brightnessMin: brightnessMin,
          brightnessMax: brightnessMax,
          colorName: colorName,
          userName: userName,
        ),
      _ => ColorFiltersDataState.initial(),
    };
  }

  factory ColorFiltersDataState.initial() {
    return const ColorFiltersDataState(
      showCriteria: ContentShowCriteria.newest,
      sortBy: ColourloversRequestOrderBy.dateCreated,
      sortOrder: ColourloversRequestSortBy.DESC,
      hueMin: 0,
      hueMax: 359,
      brightnessMin: 0,
      brightnessMax: 99,
      colorName: '',
      userName: '',
    );
  }
}
