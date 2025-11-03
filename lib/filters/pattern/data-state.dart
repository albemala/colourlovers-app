import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

@immutable
class PatternFiltersDataState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final ColorFilter colorFilter;
  final IList<ColourloversRequestHueRange> hueRanges;
  final String hex;
  final String patternName;
  final String userName;

  const PatternFiltersDataState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.colorFilter,
    required this.hueRanges,
    required this.hex,
    required this.patternName,
    required this.userName,
  });

  @override
  List<Object> get props => [
    showCriteria,
    sortBy,
    sortOrder,
    colorFilter,
    hueRanges,
    hex,
    patternName,
    userName,
  ];

  PatternFiltersDataState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    ColorFilter? colorFilter,
    IList<ColourloversRequestHueRange>? hueRanges,
    String? hex,
    String? patternName,
    String? userName,
  }) {
    return PatternFiltersDataState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      colorFilter: colorFilter ?? this.colorFilter,
      hueRanges: hueRanges ?? this.hueRanges,
      hex: hex ?? this.hex,
      patternName: patternName ?? this.patternName,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showCriteria': showCriteria.name,
      'sortBy': sortBy.name,
      'sortOrder': sortOrder.name,
      'colorFilter': colorFilter.name,
      'hueRanges': hueRanges.map((range) => range.name).toList(),
      'hex': hex,
      'patternName': patternName,
      'userName': userName,
    };
  }

  factory PatternFiltersDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'showCriteria': final String showCriteria,
        'sortBy': final String sortBy,
        'sortOrder': final String sortOrder,
        'colorFilter': final String colorFilter,
        'hueRanges': final List<dynamic> hueRanges,
        'hex': final String hex,
        'patternName': final String patternName,
        'userName': final String userName,
      } =>
        PatternFiltersDataState(
          showCriteria: ContentShowCriteria.values.byName(showCriteria),
          sortBy: ColourloversRequestOrderBy.values.byName(sortBy),
          sortOrder: ColourloversRequestSortBy.values.byName(sortOrder),
          colorFilter: ColorFilter.values.byName(colorFilter),
          hueRanges: hueRanges.map((range) {
            return ColourloversRequestHueRange.values.byName(
              range as String,
            );
          }).toIList(),
          hex: hex,
          patternName: patternName,
          userName: userName,
        ),
      _ => defaultPatternFiltersDataState,
    };
  }
}

const defaultPatternFiltersDataState = PatternFiltersDataState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  colorFilter: ColorFilter.none,
  hueRanges: IList.empty(),
  hex: '',
  patternName: '',
  userName: '',
);
