import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

@immutable
class PaletteFiltersDataState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final ColorFilter colorFilter;
  final IList<ColourloversRequestHueRange> hueRanges;
  final String hex;
  final String paletteName;
  final String userName;

  const PaletteFiltersDataState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.colorFilter,
    required this.hueRanges,
    required this.hex,
    required this.paletteName,
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
    paletteName,
    userName,
  ];

  PaletteFiltersDataState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    ColorFilter? colorFilter,
    IList<ColourloversRequestHueRange>? hueRanges,
    String? hex,
    String? paletteName,
    String? userName,
  }) {
    return PaletteFiltersDataState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      colorFilter: colorFilter ?? this.colorFilter,
      hueRanges: hueRanges ?? this.hueRanges,
      hex: hex ?? this.hex,
      paletteName: paletteName ?? this.paletteName,
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
      'paletteName': paletteName,
      'userName': userName,
    };
  }

  factory PaletteFiltersDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'showCriteria': final String showCriteria,
        'sortBy': final String sortBy,
        'sortOrder': final String sortOrder,
        'colorFilter': final String colorFilter,
        'hueRanges': final List<dynamic> hueRanges,
        'hex': final String hex,
        'paletteName': final String paletteName,
        'userName': final String userName,
      } =>
        PaletteFiltersDataState(
          showCriteria: ContentShowCriteria.values.byName(showCriteria),
          sortBy: ColourloversRequestOrderBy.values.byName(sortBy),
          sortOrder: ColourloversRequestSortBy.values.byName(sortOrder),
          colorFilter: ColorFilter.values.byName(colorFilter),
          hueRanges:
              hueRanges.map((range) {
                return ColourloversRequestHueRange.values.byName(
                  range as String,
                );
              }).toIList(),
          hex: hex,
          paletteName: paletteName,
          userName: userName,
        ),
      _ => defaultPaletteFiltersDataState,
    };
  }
}

const defaultPaletteFiltersDataState = PaletteFiltersDataState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  colorFilter: ColorFilter.none,
  hueRanges: IList.empty(),
  hex: '',
  paletteName: '',
  userName: '',
);
